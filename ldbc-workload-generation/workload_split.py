# divide the cross model workloads to files with 10 workloads each
def split_and_save(filename, input_path, output_path):
    # Read the entire file content
    with open(f"{input_path}/{filename}.txt", "r") as file:
        content = file.read()

    # Split content by "##########"
    segments = content.split("##########")

    # Remove any empty segments due to trailing or leading separators
    segments = [segment.strip() for segment in segments if segment.strip()]

    # Process and save every 10 segments into a new file
    for i in range(0, len(segments), 10):
        # Determine the output file name with an index
        output_filename = f"{output_path}/{filename}_part_{i // 10}.txt"

        # Get the next 10 segments, for the last elements, if they are less than 10, get all of them
        batch = segments[i:i + 10]

        # Write the batch to a new file
        with open(output_filename, "w") as output_file:
            output_file.write("\n##########\n".join(batch))
        print(f"Saved {output_filename}")


if __name__ == '__main__':
    path = r'C:\Users\sauzh\Documents\Work\crossmodel\workloads\gpt-wo-agg-new'
    file_name = 'cross_model_queries'
    split_and_save(file_name, path, f"{path}/cross-model-query/")
