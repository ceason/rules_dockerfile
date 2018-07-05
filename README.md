



### Notes


#### Macros
`import_dockerfile`
- input args: dockerfile(label?),dockerfile_only(bool)
- impl..
  - `_dockerfile_import`
  - `container_import`


#### Build action tools
`build-squashed-image.sh`
- input flags:
  - dockerfile      # path to dockerfile
  - dockerfile-only # don't include any other files in the docker build context
  - outfile-imageid # contains imageID/sha256
- output: imageId
- impl...
  - cd $(dirname realpath dockerfile)
  - docker build -t [tempImage] -f $(basename dockerfile) .
  - create SquashedDockerfile
    - docker inspect [tempImage]
    - FROM [tempImage].imageId as base
    - FROM scratch
    - COPY --from=base / /
    - ENV [tempImage].env
    - ENTRYPOINT [tempImage].entrypoint
    - CMD [tempImage].cmd
  - docker build -t [squashed] -f SquashedDockerfile
  - docker inspect --type=image --format='{{.ID}}' [squashed] > outfile-imageid

`save-image.sh`
- input flags:
  - imageid # file containing image to get
  - outfile-config  # output file for json image config
  - outfile-layer   # output file for image tar
- output: imageJsonConfig & layer tar file
- impl...
  - [tmpdir]
  - docker save $(cat imageid)|tar xf - -C [tmpdir]
  - rm [tmpdir]/manifest.json #
  - mv -T [tmpdir]/*.json      outfile-config
  - mv -T [tmpdir]/*/image.tar outfile-layer
  - rm -rf [tmpdir]
