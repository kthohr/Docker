
# Building the Container

From the root directory of this repository, run:

```bash
docker build --tag=r-base -f ./R/R-base.Dockerfile ./R
```

# Running the Container

```bash
docker run -it --rm r-base
```
