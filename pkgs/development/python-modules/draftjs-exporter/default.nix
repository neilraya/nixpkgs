{
  beautifulsoup4,
  buildPythonPackage,
  fetchFromGitHub,
  html5lib,
  lib,
  lxml,
  python,
}:

buildPythonPackage rec {
  pname = "draftjs-exporter";
  version = "5.0.0";
  format = "setuptools";

  src = fetchFromGitHub {
    repo = "draftjs_exporter";
    owner = "springload";
    tag = "v${version}";
    sha256 = "sha256-4MmCVRx350p6N9XqTZSo8ROI/OJ0s4aKSYH9+Oxgvf4=";
  };

  optional-dependencies = {
    lxml = [ lxml ];
    html5lib = [
      beautifulsoup4
      html5lib
    ];
  };

  checkInputs = optional-dependencies.lxml ++ optional-dependencies.html5lib;

  checkPhase = ''
    # 2 tests in this file randomly fail because they depend on the order of
    # HTML attributes
    rm tests/test_exports.py

    ${python.interpreter} -m unittest discover
  '';

  pythonImportsCheck = [ "draftjs_exporter" ];

  meta = with lib; {
    description = "Library to convert Draft.js ContentState to HTML";
    homepage = "https://github.com/springload/draftjs_exporter";
    changelog = "https://github.com/springload/draftjs_exporter/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ sephi ];
  };
}
