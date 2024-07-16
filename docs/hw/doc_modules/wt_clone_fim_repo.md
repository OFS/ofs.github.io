Perform the following steps to clone the OFS ${{ env.DESIGN }} FIM Repository:

1. Create a new directory to use as a clean starting point to store the retrieved files.
    ```bash
    mkdir OFS_BUILD_ROOT
    cd OFS_BUILD_ROOT
    export OFS_BUILD_ROOT=$PWD
    ```

2. Clone GitHub repository using the HTTPS git method
    ```bash
    git clone --recurse-submodules ${{ env.OFS_FIM_REPO_URL }}.git
    ```

3. Check out the correct tag of the repository
    ```bash
    cd ${{ env.OFS_FIM_REPO }}
    git checkout --recurse-submodules tags/${{ env.OFS_FIM_TAG }}
    ```

4. Ensure that `ofs-common` has been cloned as well

    ```bash
    git submodule status
    ```

    Example output:

    ```bash
    ofs-common (${{ env.OFS_FIM_TAG }})
    ```