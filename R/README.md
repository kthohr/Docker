
# Building the Containers

From the root directory of this repository, run:

```bash
docker build --tag=r-base -f ./R/R-base.Dockerfile ./R
```

```bash
docker build --tag=r-base-jupyter --tag=kthohr/r-base-jupyter -f ./R/R-base-jupyter.Dockerfile ./R
```

# Running the Containers

```bash
docker run -it --rm r-base
```

```bash
docker run -it --rm -p 8888:8888 r-base-jupyter
```
