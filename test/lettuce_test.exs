defmodule LettuceTest do
  use ExUnit.Case

  doctest Lettuce.Config

  @ebin_path "_build/test/lib/project/ebin/"
  @compiled_file_pattern "Elixir.{{project}}.{{module_file}}.beam"
  setup do
    full_path = "test/fixtures/#{@ebin_path}"
    File.mkdir_p!(full_path)

    "Project"
    |> file_name_for_project("ModuleInFile", "test/fixtures/")
    |> File.touch!()

    on_exit(fn ->
      File.rm_rf!("test/fixtures/_build")
    end)
  end

  test "recompiles the project if a file is touched" do
    compiled_file = file_name_for_project("Project", "ModuleInFile")

    Mix.Project.in_project(:project, "test/fixtures", fn _module ->
      init_mod_time = modification_time(compiled_file)

      File.touch!("lib/module_in_file.ex")
      Process.sleep(2000)

      assert init_mod_time != modification_time(compiled_file)
    end)
  end

  test "does notihing if non file is touched" do
    compiled_file = file_name_for_project("Project", "ModuleInFile")

    Mix.Project.in_project(:project, "test/fixtures", fn _module ->
      init_mod_time = modification_time(compiled_file)

      assert init_mod_time == modification_time(compiled_file)
    end)
  end

  defp file_name_for_project(project, module_file, prepend \\ "") do
    prepend
    |> Kernel.<>(@ebin_path)
    |> Kernel.<>(@compiled_file_pattern)
    |> String.replace("{{project}}", project)
    |> String.replace("{{module_file}}", module_file)
  end

  defp modification_time(path) do
    path
    |> File.lstat!()
    |> Map.get(:mtime)
  end
end
