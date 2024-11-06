import pandas as pd
import requests
import json
import numpy as np  # Import numpy for handling NaN values

# Class to extract JSON data from a URL
class Extract:
    def __init__(self, url):
        self.url = url

    # This function extracts the JSON from the URL
    def get_data(self):
        try:
            response = requests.get(self.url)
            response.raise_for_status()  # Raise an error for bad responses
            return response.json()
        except requests.exceptions.RequestException as e:
            print(f"Error fetching data: {e}")
            return None

# This class cleans the extracted JSON and exports it to a DataFrame
class Cleaning:
    def __init__(self, url):
        self.url = url
        self.data = None
        self.cleaned_data = []

    # Load data from the JSON
    def load_data(self):
        extractor = Extract(self.url)
        self.data = extractor.get_data()

    # Clean the JSON data
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

            # Replace NaN values with None to ensure proper handling by JSON
            pk_debut = None if pd.isna(pk_debut) else pk_debut
            pk_fin = None if pd.isna(pk_fin) else pk_fin

            # Print for debugging
            print(f"Code Ligne: {code_ligne}, PK Début: {pk_debut}, PK Fin: {pk_fin}")

            # Append the cleaned data
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

    # Filter and clean the DataFrame, remove duplicates and sort by 'code_ligne'
    def filtered_data(self):
        # Create DataFrame
        df = pd.DataFrame(self.cleaned_data)
        
        # Remove duplicates based on 'code_ligne', 'pk_debut', 'pk_fin'
        df = df.drop_duplicates(subset=['code_ligne', 'pk_debut', 'pk_fin'])
        
        # Sort by 'code_ligne'
        df = df.sort_values(by='code_ligne')
        
        # Replace NaN values with None
        df = df.replace({np.nan: None})
        
        return df

# This function processes the data, cleans it, and exports it to CSV and JSON
def data_process(url, csv_path="cleaned_data.csv", json_path="data.json"):
    data = Cleaning(url)
    data.load_data()
    data.clean_data()
    cleaned_data = data.filtered_data()

    # Export to CSV
    cleaned_data.to_csv(csv_path, index=False)
    print(f"CSV exported to: {csv_path}")

    # Export to JSON with proper handling of None
    with open(json_path, 'w', encoding='utf-8') as json_file:
        json.dump(cleaned_data.to_dict(orient='records'), json_file, indent=4, ensure_ascii=False)
    print(f"JSON exported to: {json_path}")

    return cleaned_data

# Main function to run the process
def main():
    url = 'https://www.data.gouv.fr/fr/datasets/r/c582bbe8-2d56-4273-a9f2-096b7377317b'
    csv_file_path = "Data.csv"
    json_file_path = "data.json"

    data_process(url, csv_file_path, json_file_path)

# Run the main function
if __name__ == "__main__":
    main()
