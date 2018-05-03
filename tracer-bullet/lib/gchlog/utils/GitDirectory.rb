module Gchlog

      class Vegan

        module GitDirectory

          def chrepo # :yields: the Git::Path
              Dir.chdir(getRepo()) do
                yield @repoObject;
              end
          end

          def getRepo
            return @repoDir;
          end

          def setRepo(path)
            @repoDir =  path ;
            @repoObject = File.expand_path(path);
          end

        end

      end
end
