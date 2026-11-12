import json
import time
from pathlib import Path
from urllib.request import Request, urlopen
from urllib.error import URLError, HTTPError

BASE_URL = (
    "https://raw.githubusercontent.com/"
    "yuhonas/free-exercise-db/main/exercises/"
)

JSON_FILE = Path("assets/data/exercises.json")
OUTPUT_DIR = Path("assets/images/external_exercises")

def main():
    exercises = json.loads(JSON_FILE.read_text(encoding="utf-8"))

    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

    downloaded = 0
    skipped = 0
    failed = 0

    total = sum(len(item.get("images", [])) for item in exercises)

    print(f"Total images: {total}")

    for exercise in exercises:
        for image_path in exercise.get("images", []):
            destination = OUTPUT_DIR / image_path
            destination.parent.mkdir(parents=True, exist_ok=True)

            if destination.exists() and destination.stat().st_size > 0:
                skipped += 1
                continue

            url = BASE_URL + image_path

            for attempt in range(3):
                try:
                    request = Request(
                        url,
                        headers={"User-Agent": "FitForge/1.0"},
                    )

                    with urlopen(request, timeout=20) as response:
                        image_data = response.read()

                    if not image_data:
                        raise ValueError("Empty image")

                    destination.write_bytes(image_data)
                    downloaded += 1
                    break

                except (URLError, HTTPError, TimeoutError, ValueError) as error:
                    if attempt == 2:
                        failed += 1
                        print(f"Failed: {image_path} - {error}")
                    else:
                        time.sleep(2)

        completed = downloaded + skipped + failed
        print(
            f"\rProcessed: {completed}/{total} | "
            f"Downloaded: {downloaded} | "
            f"Skipped: {skipped} | Failed: {failed}",
            end="",
            flush=True,
        )

    print("\n\nDownload finished!")
    print(f"Downloaded: {downloaded}")
    print(f"Skipped: {skipped}")
    print(f"Failed: {failed}")


if __name__ == "__main__":
    main()