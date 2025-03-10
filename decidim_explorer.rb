#!/usr/bin/env ruby

require 'json'
require 'net/http'
require 'uri'

class DecidimDocumentationLinker
  DECIDIM_DOCS_BASE_URL = 'https://docs.decidim.org/'.freeze
  DECIDIM_DOCKER_DOCS_BASE_URL = 'https://github.com/decidim/docker/blob/main/README.md'.freeze

  def initialize(project_path)
    @project_path = project_path
    @project_structure = analyze_project_structure
    @documentation_links = {}
  end

  def analyze_project_structure
    {
      config_files: Dir.glob(File.join(@project_path, '**', '{*.yml,*.rb,*.env*,docker-compose.yml}')),
      app_dirs: Dir.glob(File.join(@project_path, '{app,config,lib}')),
      docker_files: Dir.glob(File.join(@project_path, '**/Dockerfile*'))
    }
  end

  def find_documentation_links
    link_configuration_files
    link_application_directories
    link_docker_configurations
    @documentation_links
  end

  private

  def link_configuration_files
    config_mappings = {
      'database.yml' => 'configuration/database',
      'secrets.yml' => 'configuration/secrets',
      'docker-compose.yml' => 'deployment/docker-compose',
      '.env' => 'configuration/environment-variables'
    }

    @project_structure[:config_files].each do |file|
      filename = File.basename(file)
      config_mappings.each do |key, doc_path|
        if filename.include?(key)
          @documentation_links[file] = {
            decidim_docs: "#{DECIDIM_DOCS_BASE_URL}#{doc_path}",
            docker_docs: "#{DECIDIM_DOCKER_DOCS_BASE_URL}##{key.gsub('.', '-')}"
          }
        end
      end
    end
  end

  def link_application_directories
    app_mappings = {
      'app/controllers' => 'development/customization/controllers',
      'app/models' => 'development/customization/models',
      'app/views' => 'development/customization/views',
      'config/initializers' => 'configuration/initializers'
    }

    @project_structure[:app_dirs].each do |dir|
      app_mappings.each do |key, doc_path|
        if dir.include?(key)
          @documentation_links[dir] = {
            decidim_docs: "#{DECIDIM_DOCS_BASE_URL}#{doc_path}",
            docker_docs: "#{DECIDIM_DOCKER_DOCS_BASE_URL}##{key.gsub('/', '-')}"
          }
        end
      end
    end
  end

  def link_docker_configurations
    docker_mappings = {
      'Dockerfile' => 'deployment/dockerfile',
      'docker-compose.yml' => 'deployment/docker-compose'
    }

    @project_structure[:docker_files].each do |file|
      filename = File.basename(file)
      docker_mappings.each do |key, doc_path|
        if filename.include?(key)
          @documentation_links[file] = {
            decidim_docs: "#{DECIDIM_DOCS_BASE_URL}#{doc_path}",
            docker_docs: "#{DECIDIM_DOCKER_DOCS_BASE_URL}##{key.gsub('.', '-')}"
          }
        end
      end
    end
  end

  def self.generate_documentation_report(project_path)
    linker = new(project_path)
    links = linker.find_documentation_links

    puts "📚 Rapport de Documentation Decidim"
    puts "Projet : #{project_path}"
    puts "\n🔗 Liens de Documentation :"

    links.each do |file, urls|
      puts "\nFichier : #{file}"
      puts "- Documentation Decidim : #{urls[:decidim_docs]}"
      puts "- Documentation Docker  : #{urls[:docker_docs]}"
    end
  end
end

# Exemple d'utilisation
project_path = '/home/j_guerin/decidim-production/'
DecidimDocumentationLinker.generate_documentation_report(project_path)