import importlib.util
from pathlib import Path
import subprocess
import unittest


DIRECTORY = Path(__file__).resolve().parent
SPEC = importlib.util.spec_from_file_location("pins", DIRECTORY / "pins.py")
pins = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(pins)


class PinsTest(unittest.TestCase):
    def test_references(self):
        for value, expected in [
            ("owner/repo@" + "a" * 40, True),
            ('"owner/repo/path@' + "A" * 40 + '" # comment', True),
            ("owner/repo@main", False),
            ("owner/repo@" + "a" * 39, False),
            ("owner/repo@" + "a" * 41, False),
            ("owner/repo@" + "g" * 40, False),
            ("'owner/repo@v1'", False),
        ]:
            with self.subTest(value=value):
                self.assertEqual(bool(pins.PINNED.fullmatch(pins.reference(value))), expected)

    def test_fixtures(self):
        for name, code in [("good", 0), ("bad", 1)]:
            with self.subTest(name=name):
                directory = DIRECTORY / "pins-fixtures" / name
                result = subprocess.run(
                    ["bash", str(DIRECTORY / "pins.sh"), str(directory)],
                    capture_output=True, text=True, check=False,
                )
                self.assertEqual(result.returncode, code)
                if code:
                    self.assertIn(f"{directory / 'workflow.yml'}:4:", result.stderr)
                else:
                    self.assertEqual(result.stdout, "ok\n")

    def test_not_executable(self):
        self.assertEqual((DIRECTORY / "pins.sh").stat().st_mode & 0o111, 0)


if __name__ == "__main__":
    unittest.main()
