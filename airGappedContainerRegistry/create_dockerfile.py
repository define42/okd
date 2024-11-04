import os

# Define source and destination paths
source_base_path = "data/docker/registry/v2/blobs/sha256/"
destination_path = "/var/lib/registry/docker/registry/v2/blobs/sha256/"

# Generate the folder names from "00" to "ff"
all_folders = [f"{i:02x}" for i in range(256)]

# Filter to include only existing folders
existing_folders = [folder for folder in all_folders if os.path.isdir(os.path.join(source_base_path, folder))]

# Break existing folders into chunks of 16
folder_chunks = [existing_folders[i:i + 16] for i in range(0, len(existing_folders), 16)]

# Start writing the Dockerfile
with open("Dockerfile", "w") as dockerfile:
    dockerfile.write("FROM registry:2\n\n")  # Replace `your_base_image` as needed
    dockerfile.write("COPY data/docker/registry/v2/repositories/ /var/lib/registry/docker/registry/v2/\n\n")

    # Add COPY commands for each chunk of 16 existing folders
    for chunk in folder_chunks:
        sources = " ".join([os.path.join(source_base_path, folder) for folder in chunk])
        dockerfile.write(f"COPY {sources} {destination_path}\n")

print("Dockerfile has been generated successfully.")
