Room.new('rMiku', {
size={800,608},
background={
color={255,255,255},
mode=stretch,
hspeed=0,
vspeed=0,

}
,
instances={
{ object="Block",x=0,y=0 },
{ object="Block",x=0,y=32 },
{ object="Block",x=0,y=64 },
{ object="Block",x=0,y=96 },
{ object="Block",x=0,y=128 },
{ object="Block",x=0,y=160 },
{ object="Block",x=0,y=192 },
{ object="Block",x=0,y=224 },
{ object="Block",x=0,y=256 },
{ object="Block",x=0,y=288 },
{ object="Block",x=0,y=320 },
{ object="Block",x=0,y=352 },
{ object="Block",x=0,y=384 },
{ object="Block",x=0,y=416 },
{ object="Block",x=0,y=448 },
{ object="Block",x=0,y=480 },
{ object="Block",x=0,y=512 },
{ object="Block",x=0,y=544 },
{ object="Block",x=0,y=576 },
{ object="Block",x=32,y=576 },
{ object="Block",x=64,y=576 },
{ object="Block",x=96,y=576 },
{ object="Block",x=128,y=576 },
{ object="Block",x=160,y=576 },
{ object="Block",x=192,y=576 },
{ object="Block",x=224,y=576 },
{ object="Block",x=256,y=576 },
{ object="Block",x=288,y=576 },
{ object="Block",x=320,y=576 },
{ object="Block",x=352,y=576 },
{ object="Block",x=384,y=576 },
{ object="Block",x=416,y=576 },
{ object="Block",x=448,y=576 },
{ object="Block",x=480,y=576 },
{ object="Block",x=512,y=576 },
{ object="Block",x=544,y=576 },
{ object="Block",x=576,y=576 },
{ object="Block",x=608,y=576 },
{ object="Block",x=640,y=576 },
{ object="Block",x=672,y=576 },
{ object="Block",x=704,y=576 },
{ object="Block",x=736,y=576 },
{ object="Block",x=768,y=576 },
{ object="Block",x=32,y=0 },
{ object="Block",x=64,y=0 },
{ object="Block",x=96,y=0 },
{ object="Block",x=128,y=0 },
{ object="Block",x=160,y=0 },
{ object="Block",x=192,y=0 },
{ object="Block",x=224,y=0 },
{ object="Block",x=256,y=0 },
{ object="Block",x=288,y=0 },
{ object="Block",x=320,y=0 },
{ object="Block",x=352,y=0 },
{ object="Block",x=384,y=0 },
{ object="Block",x=416,y=0 },
{ object="Block",x=448,y=0 },
{ object="Block",x=480,y=0 },
{ object="Block",x=512,y=0 },
{ object="Block",x=544,y=0 },
{ object="Block",x=576,y=0 },
{ object="Block",x=608,y=0 },
{ object="Block",x=640,y=0 },
{ object="Block",x=672,y=0 },
{ object="Block",x=704,y=0 },
{ object="Block",x=736,y=0 },
{ object="Block",x=768,y=0 },
{ object="Block",x=768,y=32 },
{ object="Block",x=768,y=64 },
{ object="Block",x=768,y=96 },
{ object="Block",x=768,y=128 },
{ object="Block",x=768,y=160 },
{ object="Block",x=768,y=192 },
{ object="Block",x=768,y=224 },
{ object="Block",x=768,y=256 },
{ object="Block",x=768,y=288 },
{ object="Block",x=768,y=320 },
{ object="Block",x=768,y=352 },
{ object="Block",x=768,y=384 },
{ object="Block",x=768,y=416 },
{ object="Block",x=768,y=448 },
{ object="Block",x=768,y=480 },
{ object="Block",x=96,y=96 },
{ object="Block",x=128,y=96 },
{ object="Block",x=160,y=96 },
{ object="Block",x=192,y=96 },
{ object="Block",x=224,y=96 },
{ object="Block",x=320,y=96 },
{ object="Block",x=352,y=96 },
{ object="Block",x=384,y=96 },
{ object="Block",x=416,y=96 },
{ object="Block",x=448,y=96 },
{ object="Block",x=224,y=192 },
{ object="Block",x=192,y=192 },
{ object="Block",x=160,y=192 },
{ object="Block",x=128,y=192 },
{ object="Block",x=96,y=192 },
{ object="Block",x=96,y=288 },
{ object="Block",x=128,y=288 },
{ object="Block",x=160,y=288 },
{ object="Block",x=192,y=288 },
{ object="Block",x=224,y=288 },
{ object="Block",x=224,y=384 },
{ object="Block",x=192,y=384 },
{ object="Block",x=160,y=384 },
{ object="Block",x=128,y=384 },
{ object="Block",x=96,y=384 },
{ object="Block",x=96,y=480 },
{ object="Block",x=128,y=480 },
{ object="Block",x=160,y=480 },
{ object="Block",x=192,y=480 },
{ object="Block",x=224,y=480 },
{ object="Block",x=320,y=480 },
{ object="Block",x=352,y=480 },
{ object="Block",x=384,y=480 },
{ object="Block",x=416,y=480 },
{ object="Block",x=448,y=480 },
{ object="Block",x=448,y=352 },
{ object="Block",x=416,y=352 },
{ object="Block",x=384,y=352 },
{ object="Block",x=352,y=352 },
{ object="Block",x=320,y=352 },
{ object="Block",x=320,y=224 },
{ object="Block",x=352,y=224 },
{ object="Block",x=384,y=224 },
{ object="Block",x=416,y=224 },
{ object="Block",x=448,y=224 },
{ object="Miku",x=567,y=105 },
{ object="OutsideRoomChanger",x=800,y=512 ,onCreate=function(self) self.roomTo=Rooms.rEnd
 end},
{ object="OutsideRoomChanger",x=800,y=544 ,onCreate=function(self) self.roomTo=Rooms.rEnd
 end},
{ object="BossBlock",x=768,y=512 ,onCreate=function(self) self.itemNum=1
 end},
{ object="BossBlock",x=768,y=544 ,onCreate=function(self) self.itemNum=1
 end},
{ object="PlayerStart",x=32,y=544 },

}
,
tiles={
{ sprite="sAllTiles",x=0,y=0,xo=32,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=768,y=0,xo=32,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=768,y=576,xo=32,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=0,y=576,xo=32,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=96,y=480,xo=32,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=224,y=480,xo=32,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=320,y=480,xo=32,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=448,y=480,xo=32,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=320,y=352,xo=32,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=448,y=352,xo=32,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=320,y=224,xo=32,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=448,y=224,xo=32,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=448,y=96,xo=32,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=320,y=96,xo=32,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=224,y=96,xo=32,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=96,y=96,xo=32,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=96,y=192,xo=32,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=224,y=192,xo=32,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=224,y=288,xo=32,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=96,y=288,xo=32,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=96,y=384,xo=32,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=224,y=384,xo=32,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=128,y=96,xo=0,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=160,y=96,xo=0,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=192,y=96,xo=0,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=352,y=96,xo=0,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=384,y=96,xo=0,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=416,y=96,xo=0,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=416,y=224,xo=0,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=384,y=224,xo=0,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=352,y=224,xo=0,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=352,y=352,xo=0,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=384,y=352,xo=0,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=416,y=352,xo=0,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=416,y=480,xo=0,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=384,y=480,xo=0,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=352,y=480,xo=0,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=192,y=480,xo=0,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=160,y=480,xo=0,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=128,y=480,xo=0,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=128,y=384,xo=0,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=160,y=384,xo=0,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=192,y=384,xo=0,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=192,y=288,xo=0,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=160,y=288,xo=0,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=128,y=288,xo=0,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=128,y=192,xo=0,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=160,y=192,xo=0,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=192,y=192,xo=0,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=32,y=0,xo=0,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=64,y=0,xo=0,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=96,y=0,xo=0,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=128,y=0,xo=0,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=160,y=0,xo=0,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=192,y=0,xo=0,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=224,y=0,xo=0,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=256,y=0,xo=0,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=288,y=0,xo=0,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=320,y=0,xo=0,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=352,y=0,xo=0,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=384,y=0,xo=0,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=416,y=0,xo=0,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=448,y=0,xo=0,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=480,y=0,xo=0,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=512,y=0,xo=0,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=544,y=0,xo=0,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=576,y=0,xo=0,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=608,y=0,xo=0,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=640,y=0,xo=0,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=672,y=0,xo=0,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=704,y=0,xo=0,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=736,y=0,xo=0,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=32,y=576,xo=0,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=64,y=576,xo=0,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=96,y=576,xo=0,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=128,y=576,xo=0,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=160,y=576,xo=0,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=192,y=576,xo=0,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=224,y=576,xo=0,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=256,y=576,xo=0,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=288,y=576,xo=0,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=320,y=576,xo=0,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=352,y=576,xo=0,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=384,y=576,xo=0,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=416,y=576,xo=0,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=448,y=576,xo=0,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=480,y=576,xo=0,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=512,y=576,xo=0,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=544,y=576,xo=0,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=576,y=576,xo=0,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=608,y=576,xo=0,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=640,y=576,xo=0,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=672,y=576,xo=0,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=704,y=576,xo=0,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=736,y=576,xo=0,yo=96,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=0,y=32,xo=32,yo=64,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=0,y=64,xo=32,yo=64,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=0,y=96,xo=32,yo=64,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=0,y=128,xo=32,yo=64,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=0,y=160,xo=32,yo=64,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=0,y=192,xo=32,yo=64,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=0,y=224,xo=32,yo=64,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=0,y=256,xo=32,yo=64,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=0,y=288,xo=32,yo=64,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=0,y=320,xo=32,yo=64,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=0,y=352,xo=32,yo=64,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=0,y=384,xo=32,yo=64,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=0,y=416,xo=32,yo=64,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=0,y=448,xo=32,yo=64,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=0,y=480,xo=32,yo=64,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=0,y=512,xo=32,yo=64,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=0,y=544,xo=32,yo=64,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=768,y=32,xo=32,yo=64,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=768,y=64,xo=32,yo=64,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=768,y=96,xo=32,yo=64,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=768,y=128,xo=32,yo=64,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=768,y=160,xo=32,yo=64,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=768,y=192,xo=32,yo=64,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=768,y=224,xo=32,yo=64,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=768,y=256,xo=32,yo=64,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=768,y=288,xo=32,yo=64,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=768,y=320,xo=32,yo=64,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=768,y=352,xo=32,yo=64,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=768,y=384,xo=32,yo=64,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=768,y=416,xo=32,yo=64,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=768,y=448,xo=32,yo=64,w=32,h=32,depth=1000 },
{ sprite="sAllTiles",x=768,y=480,xo=32,yo=64,w=32,h=32,depth=1000 },

}

})
