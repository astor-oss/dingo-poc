# Copyright (c) 2020-present Baidu, Inc. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

INCLUDE(ExternalProject)

SET(SPDLOG_SOURCES_DIR ${CMAKE_SOURCE_DIR}/contrib/spdlog)
SET(SPDLOG_BINARY_DIR ${THIRD_PARTY_PATH}/build/spdlog)
SET(SPDLOG_INSTALL_DIR ${THIRD_PARTY_PATH}/install/spdlog)
SET(SPDLOG_INCLUDE_DIR "${SPDLOG_INSTALL_DIR}/include" CACHE PATH "spdlog include directory." FORCE)

IF (WIN32)
    SET(SPDLOG_LIBRARIES "${SPDLOG_INSTALL_DIR}/lib/spdlog.lib" CACHE FILEPATH "spdlog library." FORCE)
    SET(SPDLOG_CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /wd4267 /wd4530")
ELSE (WIN32)
    SET(SPDLOG_LIBRARIES "${SPDLOG_INSTALL_DIR}/lib/libspdlog.a" CACHE FILEPATH "spdlog library." FORCE)
    SET(SPDLOG_CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS})
ENDIF (WIN32)


SET(gflags_BUILD_STATIC_LIBS ON)

ExternalProject_Add(
        extern_spdlog
        ${EXTERNAL_PROJECT_LOG_ARGS}
        SOURCE_DIR ${SPDLOG_SOURCES_DIR}
        BINARY_DIR ${SPDLOG_BINARY_DIR}
        PREFIX ${SPDLOG_INSTALL_DIR}
        UPDATE_COMMAND ""
        CMAKE_ARGS -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
        -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}
        -DCMAKE_CXX_FLAGS=${SPDLOG_CMAKE_CXX_FLAGS}
        -DCMAKE_CXX_FLAGS_RELEASE=${CMAKE_CXX_FLAGS_RELEASE}
        -DCMAKE_CXX_FLAGS_DEBUG=${CMAKE_CXX_FLAGS_DEBUG}
        -DCMAKE_C_FLAGS=${CMAKE_C_FLAGS}
        -DCMAKE_C_FLAGS_DEBUG=${CMAKE_C_FLAGS_DEBUG}
        -DCMAKE_C_FLAGS_RELEASE=${CMAKE_C_FLAGS_RELEASE}
        -DCMAKE_INSTALL_PREFIX=${SPDLOG_INSTALL_DIR}
        -DCMAKE_INSTALL_LIBDIR=${SPDLOG_INSTALL_DIR}/lib
        -DCMAKE_POSITION_INDEPENDENT_CODE=ON
        -DWITH_GFLAGS=ON
        -Dgflags_DIR=${GFLAGS_INSTALL_DIR}/lib/cmake/gflags
        -DBUILD_TESTING=OFF
        -DCMAKE_BUILD_TYPE=${THIRD_PARTY_BUILD_TYPE}
        ${EXTERNAL_OPTIONAL_ARGS}
        CMAKE_CACHE_ARGS -DCMAKE_INSTALL_PREFIX:PATH=${SPDLOG_INSTALL_DIR}
        -DCMAKE_INSTALL_LIBDIR:PATH=${SPDLOG_INSTALL_DIR}/lib
        -DCMAKE_POSITION_INDEPENDENT_CODE:BOOL=ON
        -DCMAKE_BUILD_TYPE:STRING=${THIRD_PARTY_BUILD_TYPE}
)

ADD_LIBRARY(spdlog STATIC IMPORTED GLOBAL)
SET_PROPERTY(TARGET spdlog PROPERTY IMPORTED_LOCATION ${SPDLOG_LIBRARIES})
ADD_DEPENDENCIES(spdlog extern_spdlog)
