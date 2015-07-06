var paper = Raphael("holder");
var canvasID = "#holder";
paper.setViewBox(0,0,paper.width,paper.height);
var startX,startY,
viewBoxWidth = paper.width,
viewBoxHeight = paper.height,
mousedown = false,
dX,dY;
var oX = 0, oY = 0, oWidth = viewBoxWidth, oHeight = viewBoxHeight;
var viewBox = paper.setViewBox(oX, oY, viewBoxWidth, viewBoxHeight);
viewBox.X = oX;
viewBox.Y = oY;
var scale = 200;
var shapes = new Array;
var panZoom = paper.panzoom({ initialZoom: 0, initialPosition: { x: 0, y: 0} });
panZoom.enable();

function createPattern (image) {
    var c = paper.image(image, 0 , 0, 500, 500);
    c.attr("opacity", 0.75);

    var c = paper.image(image, -500 , 0, 500, 500);
    c.attr("opacity", 0.5);
    var c = paper.image(image, 500 , 0, 500, 500);
    c.attr("opacity", 0.5);
    var c = paper.image(image, 0 , -500, 500, 500);
    c.attr("opacity", 0.5);
    var c = paper.image(image, 0 , 500, 500, 500);
    c.attr("opacity", 0.5);

    var c = paper.image(image, -500 , -500, 500, 500);
    c.attr("opacity", 0.25);
    var c = paper.image(image, 500 , 500, 500, 500);
    c.attr("opacity", 0.25);
    var c = paper.image(image, 500 , -500, 500, 500);
    c.attr("opacity", 0.25);
    var c = paper.image(image, -500 , 500, 500, 500);
    c.attr("opacity", 0.25);


    for (i = -10; i < 10; i++) {
      var c = paper.path("M"+(i*500)+" 10000L"+(i*500)+" -10000");
	  c.attr("stroke", "#ff0000");
	  c.attr("stroke-dasharray", "- ");
      c.attr("stroke-width", 0.25);
      var c = paper.path("M10000 "+(i*500)+"L-10000 "+(i*500));
	  c.attr("stroke", "#ff0000");
	  c.attr("stroke-dasharray", "- ");
      c.attr("stroke-width", 0.25);
	}
    
}

function clear(){
	paper.clear();
}

function createFace(face) {
    //console.log(face);
    var pathStringArray = new Array;
    face.uvs.forEach(function(el){
                  var scale = 500;

                  pathStringArray.push(el.x/el.z*scale+" "+(-1*el.y/el.z*scale+500));

                  });
    var pathString = "M" + pathStringArray.join("L") + "z";
    //console.log(pathString);
    var path = paper.path(pathString);
    path.attr({fill: "#0000ff", stroke: "#0000ff", "fill-opacity": 0.05, "stroke-opacity": 0.9, "stroke-width": 0.5});

    shapes.push(path);
}

function createFaceWithColor(face , color) {
    //console.log(face);
    var pathStringArray = new Array;
    face.uvs.forEach(function(el){
                  var scale = 500;

                  pathStringArray.push(el.x/el.z*scale+" "+(-1*el.y/el.z*scale+500));

                  });
    var pathString = "M" + pathStringArray.join("L") + "z";
    //console.log(pathString);
    var path = paper.path(pathString);
    path.attr({fill: color, stroke: color, "fill-opacity": 0.05, "stroke-opacity": 0.9, "stroke-width": 0.5});

    shapes.push(path);
}


function uvViewResize(size) {
    paper.setSize(parseInt(size[0]),parseInt(size[1]));
};









