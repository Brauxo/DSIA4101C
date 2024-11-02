import pandas as pd
import requests
import json
import numpy as np  # Importer numpy pour utiliser np.nan

# Classe qui extrait un JSON à partir d'une url
class Extract:
    def __init__(self, url):
        self.url = url

    # Cette fonction extrait le json de l'url 
    def get_data(self):
        try:
            response = requests.get(self.url)
            response.raise_for_status()  # Raise an error for bad responses
            return response.json()
        except requests.exceptions.RequestException as e:
            print(f"Error fetching data: {e}")
            return None

# Cette classe s'occupe de trier les données du json et de les exporter dans un dataframe
class Cleaning:
    def __init__(self, url):
        self.url = url
        self.data = None
        self.cleaned_data = []

    # charge la data du json
    def load_data(self):
        extractor = Extract(self.url)
        self.data = extractor.get_data()

    # Tri le JSON afin de retenir seulement ce qui nous intéresse
    def clean_data(self):
        if not self.data:
            print("No data to clean.")
            return

        for feature in self.data:
            code_ligne = feature.get('codeLigne')
            nom_ligne = feature.get('nomLigne')
            pk_debut = feature.get('pkDebut')
            pk_fin = feature.get('pkFin')
            statut = feature.get('statut')
            troncon = feature.get('troncon')
            cantonnements = feature.get('cantonnements')
            electrifications = feature.get('electrifications')
            type_ligne = feature.get('typeLigne')
            vitesses = feature.get('vitesses')
            geometry = feature.get('geometry')
            coordinates = geometry.get('coordinates') if geometry else None


            # Remplacer les valeurs NaN par null pour eviter les bugs de conversion
            pk_debut = "null" if pd.isna(pk_debut) else pk_debut
            pk_fin = "null" if pd.isna(pk_fin) else pk_fin
            # Ajout de print pour le débogage
            print(f"Code Ligne: {code_ligne}, PK Début: {pk_debut}, PK Fin: {pk_fin}")

            # ajoute dans le dictionnaire cleaned_data ce qui a été extrait
            self.cleaned_data.append({
                'code_ligne': code_ligne,
                'nom_ligne': nom_ligne,
                'pk_debut': pk_debut,
                'pk_fin': pk_fin,
                'statut': statut,
                'troncon': troncon,
                'coordinates': coordinates,
                'cantonnements': cantonnements,
                'electrifications': electrifications,
                'type_ligne': type_ligne,
                'vitesses': vitesses
            })

    # filtre le data frame en triant par 'code_ligne'
    def filtered_data(self):
        return pd.DataFrame(self.cleaned_data).sort_values(by='code_ligne')

# cette fonction exporte le dataframe dans un fichier csv et json
def data_process(url, csv_path="cleaned_data.csv", json_path="data.json"):
    data = Cleaning(url)
    data.load_data()
    data.clean_data()
    cleaned_data = data.filtered_data()

    # Exporte en CSV
    cleaned_data.to_csv(csv_path, index=False)
    print(f"CSV exported to: {csv_path}")

    # Exporte en JSON
    with open(json_path, 'w') as json_file:
        json.dump(cleaned_data.to_dict(orient='records'), json_file, indent=4)
    print(f"JSON exported to: {json_path}")

    return cleaned_data

# la fonction main pour executer tout ça
def main():
    url = 'https://www.data.gouv.fr/fr/datasets/r/c582bbe8-2d56-4273-a9f2-096b7377317b'
    csv_file_path = "Data.csv"
    json_file_path = "data.json"

    data_process(url, csv_file_path, json_file_path)

# lance le main
if __name__ == "__main__":
    main()
