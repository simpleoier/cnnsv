# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 2.8

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:

# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list

# Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/chao/speechlab/summervacation/NeuralNetwork/DNNsrc/htklua

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/chao/speechlab/summervacation/NeuralNetwork/DNNsrc/htklua/build

# Include any dependencies generated for this target.
include CMakeFiles/htktoth_static.dir/depend.make

# Include the progress variables for this target.
include CMakeFiles/htktoth_static.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/htktoth_static.dir/flags.make

CMakeFiles/htktoth_static.dir/htktoth.cpp.o: CMakeFiles/htktoth_static.dir/flags.make
CMakeFiles/htktoth_static.dir/htktoth.cpp.o: ../htktoth.cpp
	$(CMAKE_COMMAND) -E cmake_progress_report /home/chao/speechlab/summervacation/NeuralNetwork/DNNsrc/htklua/build/CMakeFiles $(CMAKE_PROGRESS_1)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building CXX object CMakeFiles/htktoth_static.dir/htktoth.cpp.o"
	/usr/bin/c++   $(CXX_DEFINES) $(CXX_FLAGS) -o CMakeFiles/htktoth_static.dir/htktoth.cpp.o -c /home/chao/speechlab/summervacation/NeuralNetwork/DNNsrc/htklua/htktoth.cpp

CMakeFiles/htktoth_static.dir/htktoth.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/htktoth_static.dir/htktoth.cpp.i"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -E /home/chao/speechlab/summervacation/NeuralNetwork/DNNsrc/htklua/htktoth.cpp > CMakeFiles/htktoth_static.dir/htktoth.cpp.i

CMakeFiles/htktoth_static.dir/htktoth.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/htktoth_static.dir/htktoth.cpp.s"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -S /home/chao/speechlab/summervacation/NeuralNetwork/DNNsrc/htklua/htktoth.cpp -o CMakeFiles/htktoth_static.dir/htktoth.cpp.s

CMakeFiles/htktoth_static.dir/htktoth.cpp.o.requires:
.PHONY : CMakeFiles/htktoth_static.dir/htktoth.cpp.o.requires

CMakeFiles/htktoth_static.dir/htktoth.cpp.o.provides: CMakeFiles/htktoth_static.dir/htktoth.cpp.o.requires
	$(MAKE) -f CMakeFiles/htktoth_static.dir/build.make CMakeFiles/htktoth_static.dir/htktoth.cpp.o.provides.build
.PHONY : CMakeFiles/htktoth_static.dir/htktoth.cpp.o.provides

CMakeFiles/htktoth_static.dir/htktoth.cpp.o.provides.build: CMakeFiles/htktoth_static.dir/htktoth.cpp.o

# Object files for target htktoth_static
htktoth_static_OBJECTS = \
"CMakeFiles/htktoth_static.dir/htktoth.cpp.o"

# External object files for target htktoth_static
htktoth_static_EXTERNAL_OBJECTS =

libhtktoth.a: CMakeFiles/htktoth_static.dir/htktoth.cpp.o
libhtktoth.a: CMakeFiles/htktoth_static.dir/build.make
libhtktoth.a: CMakeFiles/htktoth_static.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --red --bold "Linking CXX static library libhtktoth.a"
	$(CMAKE_COMMAND) -P CMakeFiles/htktoth_static.dir/cmake_clean_target.cmake
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/htktoth_static.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/htktoth_static.dir/build: libhtktoth.a
.PHONY : CMakeFiles/htktoth_static.dir/build

CMakeFiles/htktoth_static.dir/requires: CMakeFiles/htktoth_static.dir/htktoth.cpp.o.requires
.PHONY : CMakeFiles/htktoth_static.dir/requires

CMakeFiles/htktoth_static.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/htktoth_static.dir/cmake_clean.cmake
.PHONY : CMakeFiles/htktoth_static.dir/clean

CMakeFiles/htktoth_static.dir/depend:
	cd /home/chao/speechlab/summervacation/NeuralNetwork/DNNsrc/htklua/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/chao/speechlab/summervacation/NeuralNetwork/DNNsrc/htklua /home/chao/speechlab/summervacation/NeuralNetwork/DNNsrc/htklua /home/chao/speechlab/summervacation/NeuralNetwork/DNNsrc/htklua/build /home/chao/speechlab/summervacation/NeuralNetwork/DNNsrc/htklua/build /home/chao/speechlab/summervacation/NeuralNetwork/DNNsrc/htklua/build/CMakeFiles/htktoth_static.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/htktoth_static.dir/depend
