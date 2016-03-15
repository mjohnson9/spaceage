# Contributing

## License

By contributing to this project, you hereby grant to Charles Leasure, Mark Dietzer, and Michael Johnson and to recipients of the software distributed by aforementioned a perpetual, worldwide, non-exclusive, no-charge, royalty-free, irrevocable copyright license to reproduce, prepare derivative works of, publicly display, publicly perform, sublicense, and distribute Your Contributions and such derivative works.

In addition, you agree to the [license](LICENSE.md) in the root of the project repository.

## Git

### LFS
This project uses an extension to Git called Git Large File Store (LFS). LFS stores large binary files outside of the repository to reduce the size of, and thus the time to clone, the repository. We primarily use this for maps, models, and textures. In order to work with these files, you will need to install LFS on your own computer. It can be downloaded from [https://git-lfs.github.com/](https://git-lfs.github.com/).

### Development Model
This project uses a simple development model.

The `master` branch should always be stable code, ready to run on a server.

The `develop` branch is where development happens. If you'd like to create a branch for a specific development, this is permissible.

Note that force pushes are forbidden on both develop and master.

Code is merged from develop to master via pull requests. Whenever a merge occurs, a version should be tagged at the `HEAD` of `master`.
