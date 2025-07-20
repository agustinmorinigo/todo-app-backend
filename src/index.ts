Bun.serve({
	port: 3000,
	routes: {
		'/auth': () => {
			return Response.json('HOLAAAAAAA AUTH.');
		},
		'/tasks': () => {
			return Response.json('HOLAAAAAAA TASKS.');
		},
	},
});
