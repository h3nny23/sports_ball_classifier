from pathlib import Path
from PIL import Image

def convert_dataset_to_greyscale(dataset_root="./data"):
    """
    Scans train/test splits inside dataset_root, preserves sub-directory structures,
    converts images to greyscale, and outputs them to grey_train / grey_test.
    """
    dataset_path = Path(dataset_root)
    image_extensions = {".jpg", ".jpeg", ".png", ".bmp", ".webp"}
    
    # Target splits to process
    splits = ["train", "test"]
    
    for split in splits:
        input_split_dir = dataset_path / split
        
        if not input_split_dir.exists() or not input_split_dir.is_dir():
            print(f"⚠️ Split directory not found, skipping: {input_split_dir}")
            continue
            
        # Define output split directory (e.g., ./grey_train, ./grey_test)
        output_split_dir = dataset_path.parent / f"grey_{split}"
        print(f"\n📂 Processing split '{split}' -> Saving to: {output_split_dir}")
        
        # Iterate through each sub-directory inside train/test (e.g., class_a, class_b)
        for sub_dir in input_split_dir.iterdir():
            if sub_dir.is_dir():
                # Create the matching sub-directory in the grey_ output folder
                target_sub_dir = output_split_dir / sub_dir.name
                target_sub_dir.mkdir(parents=True, exist_ok=True)
                
                print(f"  📁 Sub-folder: {sub_dir.name}")
                
                success_count = 0
                # Process images inside this sub-directory
                for file_path in sub_dir.iterdir():
                    if file_path.is_file() and file_path.suffix.lower() in image_extensions:
                        try:
                            with Image.open(file_path) as img:
                                # Convert to greyscale ('L' mode)
                                grey_img = img.convert("L")
                                
                                # Save with the exact same filename in the new target path
                                output_path = target_sub_dir / file_path.name
                                grey_img.save(output_path)
                                success_count += 1
                                
                        except Exception as e:
                            print(f"    ❌ Failed to process {file_path.name}: {e}")
                            
                print(f"    ✔ Converted {success_count} images in '{sub_dir.name}'")

# --- Run the Script ---
if __name__ == "__main__":
    convert_dataset_to_greyscale("./data")