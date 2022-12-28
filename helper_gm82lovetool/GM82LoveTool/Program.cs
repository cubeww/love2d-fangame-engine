using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Security.Policy;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace GM82LoveTool
{
    class Background
    {
        public string Sprite { get; set; } = "";
        public string Mode { get; set; } = "";
        public double Hspeed { get; set; } = 0;
        public double Vspeed { get; set; } = 0;
        public int[] Color { get; set; } = new int[3];
        public string Export()
        {
            string result = "{\n";

            result += $"color={{{Color[0]},{Color[1]},{Color[2]}}},\n";
            if (Sprite != "")
            {
                result += $"sprite=\"{Sprite}\",\n";
            }
            result += $"mode={Mode},\n";
            result += $"hspeed={Hspeed},\n";
            result += $"vspeed={Vspeed},\n";

            result += "\n}\n";
            return result;
        }
    }
    class Instance
    {
        public int X { get; set; } = 0;
        public int Y { get; set; } = 0;
        public string CreationCode { get; set; } = "";
        public string ObjectName { get; set; } = "";
        public Instance(int x, int y, string creationCode, string objectName)
        {
            X = x;
            Y = y;
            CreationCode = creationCode;
            ObjectName = objectName;
        }
    }
    class Tile
    {
        public string Sprite { get; set; } = "";
        public int X { get; set; } = 0;
        public int Y { get; set; } = 0;
        public int XO { get; set; } = 0;
        public int YO { get; set; } = 0;
        public int W { get; set; } = 0;
        public int H { get; set; } = 0;
        public int Depth { get; set; } = 0;
        public Tile(string sprite, int x, int y, int xO, int yO, int w, int h, int depth)
        {
            Sprite = sprite;
            X = x;
            Y = y;
            XO = xO;
            YO = yO;
            W = w;
            H = h;
            Depth = depth;
        }
    }
    class Room
    {
        public int Width { get; set; } = 800;
        public int Height { get; set; } = 608;
        public List<Instance> Instances { get; set; } = new List<Instance>();
        public List<Tile> Tiles { get; set; } = new List<Tile>();
        public Background Background { get; set; } = new Background();
        public string Name { get; set; } = "";
        public string CreationCode { get; set; } = "";
        public string ExportInstances()
        {
            string result = "{\n";
            foreach (var i in Instances)
            {
                string code = "";
                if (i.CreationCode != "")
                {
                    code = $",onCreate=function(self) {i.CreationCode} end";
                }
                result += $"{{ object=\"{i.ObjectName}\",x={i.X},y={i.Y} {code}}},\n";
            }

            result += "\n}\n";
            return result;
        }
        public string ExportTiles()
        {
            string result = "{\n";
            foreach (var i in Tiles)
            {
                result += $"{{ sprite=\"{i.Sprite}\",x={i.X},y={i.Y},xo={i.XO},yo={i.YO},w={i.W},h={i.H},depth={i.Depth} }},\n";
            }

            result += "\n}\n";
            return result;
        }
        public string Export()
        {
            string result = $@"Room.new('{Name}', {{
size={{{Width},{Height}}},
background={Background.Export()},
instances={ExportInstances()},
tiles={ExportTiles()}
}})
";
            return result;
        }
    }
    internal class Program
    {
        [STAThread]
        static void Main(string[] args)
        {
            var dialog = new OpenFileDialog();
            dialog.Filter = "GM82 Room File|room.txt";
            if (dialog.ShowDialog() != DialogResult.OK || dialog.FileName == "")
            {
                return;
            }
            string path = Path.GetDirectoryName(dialog.FileName) + "/";

            var room = new Room();
            room.Name = Path.GetFileName(Path.GetDirectoryName(path));

            // 1. Read settings
            foreach (string line in System.IO.File.ReadLines(path + "room.txt"))
            {
                var spline = line.Split('=');
                var key = spline[0];
                var value = spline.Length > 1 ? spline[1] : "";
                switch (key)
                {
                    case "width": room.Width = int.Parse(value); break;
                    case "height": room.Height = int.Parse(value); break;
                    case "bg_color":
                        int colorInt = int.Parse(value);
                        int b = (colorInt >> 16) & 0xFF;
                        int g = (colorInt >> 8) & 0xFF;
                        int r = colorInt & 0xFF;
                        room.Background.Color[0] = r;
                        room.Background.Color[1] = g;
                        room.Background.Color[2] = b;
                        break;
                    case "bg_source0": room.Background.Sprite = value; break;
                    case "bg_stretch0":
                        if (int.Parse(value) == 0)
                        {
                            room.Background.Mode = "stretch";
                        }
                        else
                        {
                            room.Background.Mode = "tile";
                        }
                        break;
                    case "bg_hspeed0": room.Background.Hspeed = int.Parse(value); break;
                    case "bg_vspeed0": room.Background.Vspeed = int.Parse(value); break;

                }
            }

            // 2. Read instances
            foreach (string line in System.IO.File.ReadLines(path + "instances.txt"))
            {
                var spline = line.Split(',');
                string code = "";
                if (File.Exists(path + $"{spline[3]}.gml"))
                {
                    code = File.ReadAllText(path + $"{spline[3]}.gml");
                }
                room.Instances.Add(new Instance(int.Parse(spline[1]), int.Parse(spline[2]), code, spline[0]));
            }

            // 3. Read tiles
            foreach (string line in System.IO.File.ReadLines(path + "layers.txt"))
            {
                int depth = int.Parse(line);
                foreach (string line2 in System.IO.File.ReadLines(path + $"{depth}.txt"))
                {
                    var spline = line2.Split(',');
                    room.Tiles.Add(new Tile(spline[0], int.Parse(spline[1]), int.Parse(spline[2]), int.Parse(spline[3]), int.Parse(spline[4]), int.Parse(spline[5]), int.Parse(spline[6]), depth));
                }

            }

            var exportText = room.Export();

            var sd = new SaveFileDialog();
            sd.FileName = room.Name + ".lua";
            sd.Filter = "Love Room File|*.lua";
            if (sd.ShowDialog() == DialogResult.OK)
            {
                File.WriteAllText(sd.FileName, exportText);
            }
        }
    }
}
