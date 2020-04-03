defmodule LettuceTest do
  use ExUnit.Case

  doctest Lettuce.Config

  @ebin_path "_build/test/lib/{{project}}/ebin/"
  @compiled_file_pattern "Elixir.{{project}}.ModuleFile.beam"
  @fixture_projects [:recompile, :silent_io]
                    |> Enum.map(&to_string(&1))

  setup_all do
    files_mtime =
      @fixture_projects
      |> Enum.map(fn project ->
        project
        |> fixtures_full_path
        |> File.mkdir_p!()

        beam_file = beam_file(project, true)
        File.touch!(beam_file)
        {"#{beam_file}", modification_time(beam_file)}
      end)
      |> Enum.into(%{})

    on_exit(fn ->
      @fixture_projects
      |> Enum.each(fn project ->
        # TODO _build path
        "test/fixtures/{{project}}/_build"
        |> String.replace("{{project}}", project)
        |> File.rm_rf!()
      end)
    end)

    %{files_mtime: files_mtime}
  end

  test "recompiles the project if a file is touched", %{files_mtime: files_mtime} do
    compiled_file = beam_file("recompile", false)
    touch_in_project(files_mtime, "recompile", compiled_file)
  end

  test "does notihing if non file is touched" do
    compiled_file = beam_file("recompile", false)

    Mix.Project.in_project(:recompile, "test/fixtures/recompile", fn _module ->
      init_mod_time = modification_time(compiled_file)

      assert init_mod_time == modification_time(compiled_file)
    end)
  end

  test "nothing is logged if silent", %{files_mtime: files_mtime} do
    compiled_file = beam_file("silent_io", false)

    refute ExUnit.CaptureLog.capture_log(fn ->
             touch_in_project(files_mtime, "silent_io", compiled_file)
           end) =~ "recompiling..."
  end

  defp beam_file(project, full_path?) do
    if full_path? do
      fixtures_full_path(project) <> beam_file_name(project)
    else
      "#{@ebin_path}"
      |> Kernel.<>(beam_file_name(project))
      |> String.replace("{{project}}", String.downcase(project))
    end
  end

  defp modification_time(path) do
    path
    |> File.lstat!()
    |> Map.get(:mtime)
  end

  defp beam_file_name(project) do
    module = Macro.camelize(project)
    String.replace(@compiled_file_pattern, "{{project}}", module)
  end

  defp fixtures_full_path(project) do
    fixtures_path = "test/fixtures/{{project}}/#{@ebin_path}"
    String.replace(fixtures_path, "{{project}}", project)
  end

  defp touch_in_project(initial_times, project, beam_file) do
    project
    |> String.to_existing_atom()
    |> Mix.Project.in_project("test/fixtures/#{project}", fn _module ->
      Mix.Tasks.Loadconfig.run(["config/config.exs"])

      Process.sleep(2000)
      File.touch!("lib/module_file.ex")

      assert Map.get(initial_times, "#{beam_file}") != modification_time(beam_file)
    end)
  end
end
