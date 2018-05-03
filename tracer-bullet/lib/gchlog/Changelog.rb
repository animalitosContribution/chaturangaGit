require 'Gchlog/utils/GitDirectory';
module Gchlog
  class Changelog
      include Gchlog::Vegan::GitDirectory;

      def initialize(repo, from, to)
          setRepo(repo);
          @_gitTemplate = 'git log --pretty=format:"%s" '
          @_from = from;
          @_to = to;
      end

      def _getTemplate()
        return @_gitTemplate + @_from + ".." + @_to
      end
      # genera los logs en un archivo tmp dentro de tmp usando fromto.tmp
      def _getLogs
          chrepo do
            value = %x( git status )
            puts value
          end
      end

      # invoca la estrategia en perl
      def formatLogs(strategyName)

      end

  end
end
