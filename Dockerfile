# Utiliser l'image de base Decidim compatible avec Ruby 3.0.0
FROM ghcr.io/decidim/decidim:0.28.4

# Définir le répertoire de travail
WORKDIR /code

# Mettre à jour les paquets et installer Node.js 18
RUN apt-get update && \
    apt-get install -y curl gnupg && \
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copier le Gemfile et le Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Installer les dépendances Ruby
RUN bundle install

# Copier le package.json et yarn.lock
COPY package.json yarn.lock ./

# Installer les dépendances Node.js
#RUN yarn install

# Copier le reste de l'application
COPY . .

# Précompiler les assets
#RUN bundle exec rails assets:precompile

# Exposer le port
EXPOSE 3000

# Commande par défaut
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
