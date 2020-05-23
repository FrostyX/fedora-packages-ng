def count_packages(packages):
    subpackages = sum([len(package.subpackages) for package in packages])
    return len(packages) + subpackages
