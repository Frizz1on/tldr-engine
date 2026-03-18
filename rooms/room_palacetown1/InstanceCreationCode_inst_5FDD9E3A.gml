var _centre = marker_getpos("camera_centre", 0);
if (!is_undefined(_centre)) {
    camera_pan(_centre.x, _centre.y, 0);   
}