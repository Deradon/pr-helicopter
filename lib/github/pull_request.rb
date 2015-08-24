
require 'github/resource'

#
# Endpoint for pull requests.
#  - Get list of the pull requests files
#  - Check if file
#

module Github
  # Github::PullRequest
  class PullRequest < Resource
    endpoint '/pulls'

    # Returns the full list of the pull requests files.
    # @return String[]
    def files
      @files ||= begin
        res = request.get("#{request_uri}/files")
        fail res.body unless res.code == '200'
        res.body.scan(/"filename":"([^"]+)/).flatten
      end
    end

    # Returns true if the specified file is one of the pull requested files.
    # @param {file} A file path
    # @return Boolean
    def file_included?(file)
      files.include?(file)
    end
  end
end
