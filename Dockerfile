FROM ubuntu:24.04

# Copy files to container
COPY ./src /app
COPY requirements.txt /app/requirements.txt

RUN export DEBIAN_FRONTEND=noninteractive RUNLEVEL=1 ; \
     apt-get update && apt-get install -y --no-install-recommends \
          build-essential cmake git curl ca-certificates \
          vim wget && \
	rm -rf /var/lib/apt/lists/* 

# Install conda
RUN curl -o ~/miniconda.sh -O  https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh  && \
      chmod +x ~/miniconda.sh && \
      ~/miniconda.sh -b -p /opt/conda && \
      rm ~/miniconda.sh

# Add conda to path
ENV PATH /opt/conda/bin:$PATH

# Install base conda environment
RUN conda config --set always_yes yes --set changeps1 no && conda update -q conda
RUN conda install python=3.10


# Install requirements 
WORKDIR /app
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

# Invoke fastapi main.py
CMD ["fastapi", "run", "/app/main.py", "--port", "80"]
