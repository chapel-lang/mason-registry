
use MasonUtils;
use TOML;
use FileSystem;

proc checkTomlFormat() {

}

proc readToml(brick : string) {
  here.chdir(brick);
  const versions = listdir();
  for file in versions {
    var tomlVersion = open(file, iomode.r);
    var toml = new owned(parseToml(tomlVersion));
    assert toml['brick'].!isEmpty();
    assert toml['brick']['name'] == file;
    
  }
}