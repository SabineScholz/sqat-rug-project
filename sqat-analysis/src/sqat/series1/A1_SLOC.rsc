module sqat::series1::A1_SLOC

import IO;
import ParseTree;
import String;
import List;
import util::FileSystem;

/* 

Count Source Lines of Code (SLOC) per file:
- ignore comments
- ignore empty lines

Tips
- use locations with the project scheme: e.g. |project:///jpacman/...|
- functions to crawl directories can be found in util::FileSystem
- use the functions in IO to read source files

Answer the following questions:
- what is the biggest file in JPacman?
- what is the total size of JPacman?
- is JPacman large according to SIG maintainability?
- what is the ratio between actual code and test code size?

Sanity checks:
- write tests to ensure you are correctly skipping multi-line comments
- and to ensure that consecutive newlines are counted as one.
- compare you results to external tools sloc and/or cloc.pl

Bonus:
- write a hierarchical tree map visualization using vis::Figure and 
  vis::Render quickly see where the large files are. 
  (https://en.wikipedia.org/wiki/Treemapping) 

*/

alias SLOC = map[loc file, int sloc];


int main() {
	loc jpacman = |project://jpacman-framework/src|;
	//fs = crawl(jpacman);
	return sloc(jpacman);
}



int sloc(loc project) {
    n = 0;
    for (loc file <- find(project, "java")) {
        //println(readFile(file));
        str codeString = removeNonCodeLinesFromString(readFile(file));
        //println(codeString);
        n += countLinesInString(codeString);
    }
    return n;
}

int countLinesInString(str string) {
	return size(split("\n", string));
}

str removeNonCodeLinesFromString(str string) {	
	if (/<pref:^.*?><comment:\/\*.*?\*\/><suffix:.*$>/s := string) { // removes /* whatever */
		return removeNonCodeLinesFromString(pref + suffix);
	}
	if (/<pref:^.*?><comment:\/\/.*?\n><suffix:.*$>/s := string) { // removes // whatever \n
		return removeNonCodeLinesFromString(pref + suffix);
	}
	if (/<pref:^.*?><comment:\/\/.*$>/s := string) { // removes // whatever EOF
		return removeNonCodeLinesFromString(pref);
	}
	if (/<pref:^.*?\n><blankLine:\s*\n><suffix:.*$>/s := string) { // removes blank line ending with \n
		return removeNonCodeLinesFromString(pref + suffix);
	}
	if (/<pref:^.*?><blankLine:\n\s*$>/s := string) { // removes blank line ending with EOF
		return pref;
	}
	return string;
}

/* If we think of comments as blank lines, or "non-code" lines, then the blank lines would be:
    (space | tab | ("/*" + anything(including '\n') + "* /"))* + ("//" + anything(exluding '\n')) + "\n" .
    
    A code line would be anything thats left after that.
    */
    
int countCodeLinesInFile(loc file) = ( 0 | it + 1 | /[\ \t(\/\*[.\n\r]*?\*\/)]*?(\/\/.*?)??\n/ !:= readFile(file) );

int countCodeLinesInFile2(loc file) {
    int codeLines = 0;
    for (/[\ \t(\/\*[.\n\r]*?\*\/)]*?(\/\/.*?)??\n/ !:= readFile(file)) {
        codeLines += 1;
    }
    return codeLines;
}

void main2() {
	xs = {1,2,3,4}; //set 
	x = {<1,2>, <2,3>};
}

int countDirs(FileSystem fs) {
  switch(fs) {
    case directory(loc l, set[FileSystem] children): {
      int countSubdirs = 0;
      for (FileSystem child <- children) {
       countSubdirs += countDirs(child);
      }
      return countSubdirs + 1;
    }
    case file(_): 
		return 0;
    }

}

int countDirs2(FileSystem fs) {
  int count = 0;
  visit(fs) {
    case directory(loc l, set[FileSystem] children):
      count += 1;
     }
	return count;
}



int countDirs3(FileSystem fs) = ( 0 | it + 1 | /directory(_, _) := fs );

int countDirs4(FileSystem fs) {
	int count = 0;
	for(/directory(_,_) := fs) {
		count += 1;
	}
	return count;
}


          

int countSLOC(loc file) {
	n = countTotalLines(file);
	n -= countBlankLines(file);
	n -= countCommentLines(file);
	return n;
}

int countTotalLines(loc file) {
	return 0;
}


int countBlankLines(loc file) {
	return 0;
}


int countCommentLines(loc file) {
	return 0;
}
