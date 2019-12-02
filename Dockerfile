#Base image with emscripten
ARG QT_WASM_BASE=

FROM $QT_WASM_BASE AS boost-stage
MAINTAINER Lennart E.

#Install boost headers in emscripten directory
RUN mkdir -p /tmp/boost ;\
	cd /tmp/boost ;\
	wget -Oboost.tar.bz2 https://vorboss.dl.sourceforge.net/project/boost/boost/1.66.0/boost_1_66_0.tar.bz2 ;\
	tar xjf boost.tar.bz2 ;\
	cd /tmp/boost/boost*/ ;\
	./bootstrap.sh ;\
	./b2 toolset=emscripten cxxflags=-std=c++17 system ;\
	mv /tmp/boost/boost_*/boost /boost/ ;\
	rm -rf /tmp/boost

#Copy files to new stage
FROM $QT_WASM_BASE
MAINTAINER Lennart E.
COPY --from=boost-stage /boost/ /emsdk_portable/sdk/system/include/boost/
