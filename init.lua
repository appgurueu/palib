function collidepoint(rect, point) --Whether 2d vector is on 2d rectangle
	if (rect.x > point.x or rect.y > point.y or rect.x+rect.w < point.x or rect.y+rect.h < point.y) then
		return false
	end
	return true
end

function mal(v,w)
	return {x=v.x*w.x,y=v.y*w.y}
end

function plus(v,w)
	return {x=v.x+w.x,y=v.y+w.y}
end

function pointingat(cube, camera, offset)
    local surface = {x=cube.pos.x, y=cube.pos.z, w=cube.dim.x, h=cube.dim.z}
    local side = {x=cube.pos.x, y=cube.pos.y, w=cube.dim.x, h=cube.dim.y}
    local front = {x=cube.pos.y, y=cube.pos.z, w=cube.dim.y, h=cube.dim.z}
    local side_z = cube.pos.z-camera.position.z+offset*cube.dim.z
    local side_point = plus(mal({x=side_z,y=side_z,z=0},camera.friction_z),{x=camera.position.x, y=camera.position.y})
    local surface_y = cube.pos.y-camera.position.y+offset*cube.dim.y
    local surface_point = plus(mal({x=surface_y,y=surface_y,z=0},camera.friction_y),{x=camera.position.x, y=camera.position.z, z=0})
    local front_x = cube.pos.x-camera.position.x+offset*cube.dim.x
    local front_point = plus(mal({x=front_x,y=front_x,z=0},camera.friction_x),{x=camera.position.y, y=camera.position.z, z=0})
    if (collidepoint(surface,surface_point)) then
		return vector.subtract({x=surface_point.x,y=cube.pos.y+offset*cube.dim.y,z=surface_point.y},camera.position)
	end
	if (collidepoint(side,side_point)) then
		return vector.subtract({x=side_point.x,y=side_point.y,z=cube.pos.z+offset*cube.dim.z},camera.position)
	end
	if (collidepoint(front,front_point)) then
		return vector.subtract({x=cube.pos.x+offset*cube.dim.x,y=front_point.x,z=front_point.y},camera.position)
	end
end

function pointing_at(cube, camera)
    for _,o in pairs({0.5,-0.5}) do
		local pa = pointingat(cube,camera,o)
		if pa then
			return pa
        end
    end
end

--Use this function : it determines whether a camera (pos(vector, dir(vector))) is pointing at a cube (pos(vector), dim(vector))
function is_pointing_at(cube,camera)
	local cam={position=camera.pos}
	local d=vector.normalize(camera.dir)
	local x=d.x
	local y=d.y
	local z=d.z
	if (x == 0) then
		x=x+00000000.1 --Little bias to avoid divison by 0
	end
	if (y == 0) then
		y=y+00000000.1 --Little bias to avoid divison by 0
	end
	if (z == 0) then
		z=z+00000000.1 --Little bias to avoid divison by 0
	end
	cam.friction_x={x=y/x,y=z/x}
	cam.friction_y={x=x/y,y=z/y}
	cam.friction_z={x=x/z,y=y/z}
	return pointing_at(cube,cam)
end
