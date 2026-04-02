.PHONY: dev build build-frontend build-desktop sign clean

# Frontend dev server (hot reload)
dev:
	cd frontend && gleam run -m lustre/dev start

# Full build: frontend + desktop + sign
build: build-frontend build-desktop sign

build-frontend:
	cd frontend && gleam run -m lustre/dev build

build-desktop:
	mkdir -p desktop/frontend/dist
	cp -r frontend/dist/* desktop/frontend/dist/
	cd desktop && wails build

sign:
	cp secrets/gon-sign.json desktop/build/darwin/gon-sign.json
	cd desktop && gon -log-level=info ./build/darwin/gon-sign.json
	ditto -c -k --sequesterRsrc --keepParent desktop/build/bin/{{project_name}}.app desktop/build/bin/{{project_name}}.zip

build-windows:
	mkdir -p desktop/frontend/dist
	cp -r frontend/dist/* desktop/frontend/dist/
	cd desktop && wails build -platform windows/amd64

clean:
	rm -rf desktop/frontend/dist
	rm -rf frontend/dist
	rm -rf desktop/build
