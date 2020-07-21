idf_component_register(SRCS "hello_world_main.c"
                    INCLUDE_DIRS ".")

target_link_libraries(__idf_main libfib.a)
