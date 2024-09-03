let songs = "";
songs = songs.split(",");

songs.map((note, index) => {
    if (parseInt(note) > 100) {
        songs[index] = (parseInt(note) * 3/4).toFixed(0).toString();
    }
});

songs = songs.join(",");
console.log(songs);