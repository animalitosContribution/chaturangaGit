outputFile = "C:\\Users\\danye\\git\\mine\\DocumentorJS" #ARGV[0];
fromRef = "94d7d96b732e8447daaa" #ARGV[1];
toRef = "4ec7a0f17f0806e80"#ARGV[2];
strategy = 1;#ARGV[3];

changelogs = [];
changelogsParsed = [];
gitConfig = {
    "command" => 'git log --pretty=format:"%s" ',
    "refRange" => " %<reffrom>s..%<refto>s"
};

gitFormat = {
    "karma" => {
        "regex" => /\b(?<type>\w+)(?:\((?<scope>\w+)\))?:(?<subject>[\w\s]*)\b/,
        "token" => {
          "BRANCH" => "develop|master|feat|hotfix"
        },
        "skip" => ["merge %{BRANCH}%"],
         "sections" => {
           "feat" => "Funcionalidad",
           "fix"  => "Corrección" ,
           "docs" => "Documentación",
           "style" => "Estilo",
           "refactor" => "Refactorizacion",
           "test" => "Prueba",
           "chore" =>  "Archivo",
           "unknown" => "Desconocido"
         }
    }
};

class String
  def toSentence
    self.gsub(/::/, '/').
    gsub(/([A-Z]+)([A-Z][a-z])/,'\1 \2').
    gsub(/([a-z\d])([A-Z])/,'\1 \2').
    tr("-", " ")
  end
end

def chrepo(dir) # :yields: the Git::Path
    Dir.chdir(dir) do
      yield File.expand_path(dir)
    end
end

def changelog(gitConfig, outputFile, fromRef, toRef)
  chrepo(outputFile) do
    cmd  =  gitConfig["command"] + format(gitConfig["refRange"] ,reffrom: fromRef, refto:toRef )
    %x( #{cmd} ).each_line {|s|
      yield s
    }
  end
end

def parseSubject(config, matches, myKeys)
    if matches["subject"] == nil
        return false;
    end
    return matches["subject"];
end

def parseScope(config, matches, myKeys)
  if matches["scope"] != nil
    return  " en " + matches["scope"].toSentence
  end
  return " general ";
end

def parseType(config, matches, myKeys)
  typeTmp = myKeys.grep(/#{matches["type"]}/i);
  if typeTmp.length <= 0
      return false;
  end
  return config.fetch("sections").fetch(typeTmp[0])
end

def do_karma(matches, changelog, config)
  myKeys = config["sections"].keys
  type = parseType(config, matches, myKeys);
  scope = parseScope(config, matches, myKeys);
  subject = parseSubject(config, matches, myKeys);

  if type == nil || subject == nil
    print "NOT A VALID CHANGELOG LINE:";
    return false;
  end
  return  type + scope +" => "+ subject;
end

changelog(gitConfig,outputFile, fromRef, toRef) do |changelog|
  matches = gitFormat["karma"]["regex"].match(changelog)
  if matches
    changelogsParsed.push(send("do_karma", matches, changelog, gitFormat["karma"] ));
    changelogs.push(changelog);
  end
end
print "\n================CHANGELOG================\n";
changelogs.each do |parsed|
  print parsed + "\n" ;
end
print "\n\n================CHANGELOG PARSED================\n";
changelogsParsed.each do |parsed|
  print parsed  + "\n";
end
