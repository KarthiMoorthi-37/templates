{ pkgs, version ? "latest", importAlias ? "@/*", language ? "ts", packageManager ? "npm", srcDir ? false, eslint ? false, app ? false, tailwind ? false, ... }: {

  packages = [ pkgs.nodejs_20 pkgs.yarn pkgs.nodePackages.pnpm pkgs.bun pkgs.j2cli ];

  bootstrap = ''
		mkdir "$out"
		${if packageManager == "bun" then "bunx" else "npx"} create-next-app@${version} "$out" \
			--yes \
			--skip-install \
			--import-alias=${importAlias} \
			--${language} \
			--use-${packageManager} \
			${if eslint then "--eslint" else "--no-eslint"} \
			${if srcDir then "--src-dir" else "--no-src-dir"} \
			${if app then "--app" else "--no-app"} \
			${if tailwind then "--tailwind" else "--no-tailwind"}

		mkdir -p "$out"/.idx
		chmod -R u+w "$out"
    packageManager=${packageManager} j2 ${./devNix.j2} -o "$out/.idx/dev.nix"
		cp -rf ${./.idx/airules.md} "$out/.idx/airules.md"
		cp -rf "$out/.idx/airules.md" "$out/GEMINI.md"
		chmod -R +w "$out"
  '';
}
