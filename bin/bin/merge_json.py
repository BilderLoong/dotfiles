import argparse
import json
import os


def merge_and_update_json_file(file_path, object_to_merge):
    try:
        with open(file_path, "r") as json_file:
            original_data = json.load(json_file)
    except FileNotFoundError:
        original_data = {}

    # Merge the objects
    merged_data = {**original_data, **object_to_merge}

    with open(file_path, "w") as json_file:
        json.dump(merged_data, json_file)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Merge objects into a JSON file.")
    parser.add_argument("file_path", help="The path of the JSON file to merge.")
    parser.add_argument("object_to_merge", help="The JSON object to merge, as a string.")

    args = parser.parse_args()

    object_to_merge = json.loads(args.object_to_merge)

    merge_and_update_json_file(args.file_path, object_to_merge)
