#!/bin/bash
mkdir data
cd data
wget https://raw.githubusercontent.com/undeadpixel/reinvent-randomized/master/training_sets/chembl.training.smi
wget https://raw.githubusercontent.com/undeadpixel/reinvent-randomized/master/training_sets/chembl.validation.smi
wget https://raw.githubusercontent.com/undeadpixel/reinvent-randomized/master/training_sets/decorator_scaffolds_drd2.training.smi
wget https://raw.githubusercontent.com/undeadpixel/reinvent-randomized/master/training_sets/decorator_scaffolds_recap.training.smi
wget https://raw.githubusercontent.com/undeadpixel/reinvent-randomized/master/training_sets/decorator_scaffolds_drd2.validation.smi
wget https://raw.githubusercontent.com/undeadpixel/reinvent-randomized/master/training_sets/decorator_scaffolds_recap.validation.smi
wget https://raw.githubusercontent.com/undeadpixel/reinvent-randomized/master/training_sets/gdb13.1M.training.smi
wget https://raw.githubusercontent.com/undeadpixel/reinvent-randomized/master/training_sets/gdb13.1M.validation.smi
wget https://raw.githubusercontent.com/alexarnimueller/SMILES_generator/master/data/chembl24_10uM_20-100.csv
wget https://deepchemdata.s3-us-west-1.amazonaws.com/datasets/pubchem.zip
wget https://cactus.nci.nih.gov/osra/uspto-validation-updated.zip
unzip pubchem.zip
unzip uspto-validation-updated.zip
rm uspto-validation-updated.zip pubchem.zip

touch smiles_data.smi
for filename in pubchem/*.smi; do
    cat $filename >> smiles_data.smi
done
rm -rf pubchem/
cat chembl.training.smi >> smiles_data.smi
cat chembl.validation.smi >> smiles_data.smi
cat decorator_scaffolds_recap.training.smi >> smiles_data.smi
cat decorator_scaffolds_recap.validation.smi >> smiles_data.smi
cat decorator_scaffolds_drd2.training.smi >> smiles_data.smi
cat decorator_scaffolds_drd2.validation.smi >> smiles_data.smi
cat gdb13.1M.training.smi >> smiles_data.smi
cat gdb13.1M.validation.smi >> smiles_data.smi
cat chembl24_10uM_20-100.csv >> smiles_data.smi
uniq  smiles_data.smi > smiles_data_unique.smi
shuf smiles_data_unique.smi > shuffled_unique_smiles.smi
{
  head -n 100000 > validation.smi
  head -n 100000 > evaluation.smi
  cat > training.smi
} < shuffled_unique_smiles.smi
rm shuffled_unique_smiles.smi smiles_data.smi smiles_data_unique.smi
rm decorator_scaffolds_recap.training.smi decorator_scaffolds_recap.validation.smi decorator_scaffolds_drd2.training.smi decorator_scaffolds_drd2.validation.smi chembl.training.smi chembl.validation.smi gdb13.1M.training.smi gdb13.1M.validation.smi chembl24_10uM_20-100.csv
mkdir training_images validation_images evaluation_images
cd ..
python create_images_from_simles.py --input_file data/validation.smi --output_folder data/validation_images
python create_images_from_simles.py --input_file data/evaluation.smi --output_folder data/evaluation_images
python create_images_from_simles.py --input_file data/training.smi --output_folder data/training_images