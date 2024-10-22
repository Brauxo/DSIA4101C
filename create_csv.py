import pandas as pd
import requests

# Classe qui extrait un JSON à partir  d'une url
class extract:
    def __init__(self, url):
        self.url = url

    # Cette fonction extrait le json de l'url 
    def get_data(self):
        response = requests.get(self.url)
        if response.status_code == 200:
            return response.json()
        else:
            raise Exception(f"Failed to fetch data: {response.status_code}")

# Cette classe s'occupe de trier les données du json et de les exporter dans un dataframe
class cleaning:
    def __init__(self, url):
        self.url = url
        self.data = None
        self.cleaned_data = None

    # charge la data du json
    def load_data(self):
        extractor = extract(self.url)
        self.data = extractor.get_data()

    # Tri le JSON afin de retenir seulement ce qui nous intéresse
    def clean_data(self):
        data_list = []

        for feature in self.data:
            code_ligne = feature.get('codeLigne', None)
            nom_ligne = feature.get('nomLigne', None)
            pk_debut = feature.get('pkDebut', None)
            pk_fin = feature.get('pkFin', None)
            statut = feature.get('statut', None)
            troncon = feature.get('troncon', None)
            cantonnements = feature.get('cantonnements', None)
            electrifications = feature.get('electrifications', None)
            type_ligne = feature.get('typeLigne', None)
            vitesses = feature.get('vitesses', None)
            geometry = feature.get('geometry', None)
            coordinates = geometry.get('coordinates', None) if geometry else None

            vitesses_clean = []
            if vitesses:
                for vitesse in vitesses:
                    if 'detail' in vitesse:
                        # Tente de convertir en entier, sinon mets None
                        try:
                            vitesses_clean.append(int(vitesse.get('detail')))
                        except (ValueError, TypeError):
                            vitesses_clean.append(None)

            data_list.append({
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
                'vitesses': vitesses_clean
            })

        self.cleaned_data = pd.DataFrame(data_list)

    # filtre le data frame en triant par 'code_ligne'
    def filtered_data(self):
        return self.cleaned_data.sort_values(by='code_ligne')

# cette fonction exporte le dataframe dans un fichier csv
def data_process(url, csv_path="cleaned_data.csv"):
    data = cleaning(url)
    data.load_data()
    data.clean_data()
    cleaned_data = data.filtered_data()

    cleaned_data.to_csv(csv_path, index=False)
    print(f"Data has been exported to: {csv_path}")


    return cleaned_data

#la fonction main pour executer tout ca
def main():
    url = 'https://www.data.gouv.fr/fr/datasets/r/c582bbe8-2d56-4273-a9f2-096b7377317b'
    csv_file_path = "Data.csv"

    data_process(url, csv_file_path)

# lance le main
if __name__ == "__main__":
    main()