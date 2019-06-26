
use TOML;
use FileSystem;

proc checkTomls() {
  var bricks = listdir('Bricks');
  const env = getEnv('PWD');
  for brick in bricks {
    here.chdir(env + '/Bricks/' + brick);
    var toml = listdir();
    var toParse = open(toml, iomode.r);
    var tomlFile = new owned(parseToml(toParse));
    assert(tomlFile['brick']['name'].s == brick);
  }
  return 0;
}


extern proc getenv(name : c_string) : c_string;
proc getEnv(name : string) : string {
  var cname: c_string = name.c_str();
  var value = getenv(cname);
  return value:string;
}


checkTomls();