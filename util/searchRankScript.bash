#!/usr/bin/env bash
# Clone the package to be published from latest commit
package=$(git diff --name-only HEAD HEAD~1)
echo "[LOG]: Package path from git command = ${package}"

# check for TOML file
if [[ $(basename -- $package) != *".toml"* ]]; then
  echo "Not TOML FILE"
  exit 0
fi

path="$package"
echo "[LOG]: path = $(dirname ${path})"
FILE=$package
f="$(basename -- "$FILE")"
echo "[LOG]: Package TOML file = ${f}"
source="$(grep source "$path"| cut -d= -f2)"
fixed=$(echo "$source" 2> /dev/null | tr -d '"')
echo "[LOG]: Package url = ${fixed}"
name="$(grep name "$path" | cut -d= -f2 | tr -d '"' | tr -d ' ')"
echo "[LOG]: Package name = ${name}"
version="$(grep version "$path" | cut -d= -f2 | tr -d '"' | tr -d ' ')"
# convert version from 0.1.0 to 0_1_0
version=$(echo ${version} | tr '.' '_')
echo "[LOG]: Version = ${version}"
git clone "$fixed" "$(dirname ${path})/newPackage"
packagePath="$(dirname ${path})/newPackage"
echo "$name cloned succesfully at $packagePath"

# Perform a series of check on the package and award points
mason=$packagePath/Mason.toml
testDir=$packagePath/test/
exampleDir=$packagePath/example/
srcDir=$packagePath/src/
score=0
countForREADME=$(ls -l $packagePath/README.* 2>/dev/null | wc -l)
if [ "$countForREADME" != 0 ]
then
  echo "README found in package"
  score=$((score+1))
fi
countForModuleFile=$(ls -l $packagePath/src/*.chpl 2>/dev/null | wc -l)
if [ "$countForModuleFile" != 0 ]
then
  echo "ModuleFile found in package"
  score=$((score+1))
fi
[[ -f "$mason" ]] && score=$((score+1)) && echo "Mason.toml found in package"
[[ -d "$testDir" ]] && score=$((score+1)) && echo "test dir found in package"
[[ -d "$exampleDir" ]] && score=$((score+1)) && echo "example dir found in package"
[[ -d "$srcDir" ]] && score=$((score+1)) && echo "src dir found in package"

# minimum score for a package from generic checks
minScore=6

# points for number of examples (max 3)
countForExamples=$(ls -l $exampleDir/*.chpl 2>/dev/null | wc -l)
echo "Found $countForExamples examples in package."
maxScoreExamples=3
if [ "$countForExamples" -gt "$maxScoreExamples" ] 
then 
  countForExamples=$maxScoreExamples
fi
score=$((score+countForExamples))

# points for number of tests (max 3)
maxScoreTests=3
countForTests=$(ls -l $testDir/*.chpl 2>/dev/null | wc -l)
echo "Found $countForTests tests in package."
if [ "$countForTests" -gt "$maxScoreTests" ]
then
  countForTests=$maxScoreTests
fi
score=$((score+countForTests))
echo "Total score generated for $name = $score"

# normalize the score to 100
maxScore=$((minScore+maxScoreTests+maxScoreExamples))
score=$(echo "scale=2 ; $score / $maxScore" | bc)
score=$(echo "$score * 100" | bc)
score=${score%.*}
echo "Score normalized to $score"

# check if package name and version already exists 
if grep "$name.$version" cache.toml
then 
  echo "Package already exists. Cannot overwrite."
  exit 1
fi

# append package score to TOML cache file
echo "[$name.$version]" >> cache.toml
echo "score = $score" >> cache.toml
echo "Wrote '$name = $score' to cache.toml"

