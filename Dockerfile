# Utilise une image de base avec Python 3.6
FROM python:3.6-slim

# Maintient les best practices de conformité pour le label
LABEL maintainer="vous@domaine.com"

# Copier le fichier requirements.txt pour installer les dépendances
COPY requirements.txt /opt/

# Installer les dépendances mentionnées dans `requirements.txt`
RUN pip install --no-cache-dir -r /opt/requirements.txt

# Copier l'intégralité du contexte de build vers /opt dans le conteneur
COPY . /opt/

# Exposer le port 8081
EXPOSE 8081

# Définir /opt comme répertoire de travail
WORKDIR /opt

# Définir la commande d'entrée du conteneur pour exécuter `app.py`
ENTRYPOINT ["python", "app.py"]
