# Copyright 2014 Open Source Robotics Foundation, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#
# Install a Python package (and its recursive subpackages).
#
# :param package_name: the Python package name
# :type package_name: string
# :param PACKAGE_DIR: the path to the Python package directory (default:
#   <package_name> folder relative to the CMAKE_CURRENT_LIST_DIR)
# :type PACKAGE_DIR: string
#
macro(ament_python_install_package)
  _ament_cmake_python_register_environment_hook()
  _ament_cmake_python_install_package(${ARGN})
endmacro()

function(_ament_cmake_python_install_package package_name)
  cmake_parse_arguments(ARG "" "PACKAGE_DIR" "" ${ARGN})
  if(ARG_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "ament_python_install_package() called with unused "
      "arguments: ${ARG_UNPARSED_ARGUMENTS}")
  endif()

  if(NOT ARG_PACKAGE_DIR)
    set(ARG_PACKAGE_DIR "${CMAKE_CURRENT_LIST_DIR}/${package_name}")
  endif()
  if(NOT IS_ABSOLUTE "${ARG_PACKAGE_DIR}")
    set(ARG_PACKAGE_DIR "${CMAKE_CURRENT_LIST_DIR}/${ARG_PACKAGE_DIR}")
  endif()

  if(NOT EXISTS "${ARG_PACKAGE_DIR}/__init__.py")
    message(FATAL_ERROR "ament_python_install_package() the Python package "
      "folder '${ARG_PACKAGE_DIR}' doesn't contain an '__init__.py' file")
  endif()

  _ament_cmake_python_register_environment_hook()

  if(NOT PYTHON_INSTALL_DIR)
    message(FATAL_ERROR "ament_python_install_package() variable "
      "'PYTHON_INSTALL_DIR' must not be empty")
  endif()
  install(
    DIRECTORY "${ARG_PACKAGE_DIR}/"
    DESTINATION "${PYTHON_INSTALL_DIR}/${package_name}"
    PATTERN "*.pyc" EXCLUDE
    PATTERN "__pycache__" EXCLUDE
  )
  # TODO(dirk-thomas): optionally compile Python files

  if(package_name IN_LIST AMENT_CMAKE_PYTHON_INSTALL_INSTALLED_NAMES)
    message(FATAL_ERROR
      "ament_python_install_package() a Python module file or package with "
      "the same name '${package_name}' has been installed before")
  endif()
  list(APPEND AMENT_CMAKE_PYTHON_INSTALL_INSTALLED_NAMES "${package_name}")
  set(AMENT_CMAKE_PYTHON_INSTALL_INSTALLED_NAMES
    "${AMENT_CMAKE_PYTHON_INSTALL_INSTALLED_NAMES}" PARENT_SCOPE)
endfunction()
