FROM arm64v8/python:3.12
COPY --from=ghcr.io/astral-sh/uv:latest /uv /bin/uv



RUN apt-get update && apt-get install -y \
    avahi-daemon \
    # cmake \
    libavcodec-dev libavformat-dev libswscale-dev \
    libgstreamer-plugins-base1.0-dev libgstreamer1.0-dev \
    libgtk-3-dev
    # wget \
    # git \
    # unzip

WORKDIR /app


ADD pyproject.toml /app/pyproject.toml
RUN uv lock



RUN uv sync --frozen --no-install-project

ADD . /app

RUN uv sync --frozen


# RUN wget -O opencv.zip https://github.com/opencv/opencv/archive/4.10.0.zip \
#     && unzip opencv.zip \
#     && mv opencv-4.10.0 opencv \
#     && mkdir -p build && cd build \
#     && cmake -D CMAKE_INSTALL_PREFIX=/usr/local -D BUILD_opencv_java=OFF -D BUILD_opencv_python2=OFF -D BUILD_opencv_python3=ON -D PYTHON_DEFAULT_EXECUTABLE=$(which python3) -D INSTALL_C_EXAMPLES=OFF -D INSTALL_PYTHON_EXAMPLES=OFF -D BUILD_EXAMPLES=OFF -D WITH_CUDA=OFF -D WITH_GSTREAMER=ON -D BUILD_TESTS=OFF -D BUILD_PERF_TESTS=OFF ../opencv \
#     && make -j4 \
#     && make install \
#     && ln -s /usr/local/lib/python3.12/site-packages/cv2 /app/.venv/lib/python3.12/site-packages/cv2


CMD [ "uv", "run", "python", "harmonize.py"]