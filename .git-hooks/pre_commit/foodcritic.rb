module Overcommit
  module Hook
    module PreCommit
      # Lint cookbook using Foodcritic
      #
      # See http://www.foodcritic.io
      class Foodcritic < Base
        FILTER = /recipies|resources|templates|attributes|files|metadata/

        def run
          files = applicable_files.grep FILTER
          return :pass if files.empty?

          result = execute(command)
          return :pass if result.success?

          [:fail, result.stdout]
        end
      end
    end
  end
end
