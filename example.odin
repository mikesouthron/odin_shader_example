package main

import "vendor:glfw"
import gl "vendor:OpenGL"

import "core:os"
import "core:fmt"
import "core:strings"

main :: proc() {
    glfw.Init()

    window_handle := glfw.CreateWindow(1024, 768, "Test", nil, nil)
    glfw.MakeContextCurrent(window_handle)
    
    gl.load_up_to(3, 3, glfw.gl_set_proc_address)

    glfw.WindowHint(glfw.CONTEXT_VERSION_MAJOR, 3);
    glfw.WindowHint(glfw.CONTEXT_VERSION_MINOR, 3);
    glfw.WindowHint(glfw.OPENGL_PROFILE, glfw.OPENGL_CORE_PROFILE);
    glfw.WindowHint(glfw.OPENGL_FORWARD_COMPAT, 1)

    vs_data, ok := os.read_entire_file("test.vs")
    if !ok {
	fmt.println("Could not open file")
    }
    vs_content := strings.clone_to_cstring(string(vs_data))
    
    v_shader := gl.CreateShader(gl.VERTEX_SHADER)
    gl.ShaderSource(v_shader, 1, &vs_content, nil)
    gl.CompileShader(v_shader)

    success: i32
    gl.GetShaderiv(v_shader, gl.COMPILE_STATUS, &success)
    if success == 0 {
	info_log := make([^]u8, 512)
	gl.GetShaderInfoLog(v_shader, 512, nil, info_log)
	fmt.printf("%s\n", info_log)
    } else {
	fmt.printf("%d", success)
    }
}
