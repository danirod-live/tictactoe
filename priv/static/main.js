let socket = new WebSocket("ws://localhost:3000/game");

let who_i_am;

        socket.addEventListener('message', msg => {
            let payload = JSON.parse(msg.data);
            switch (payload.event) {
                case "ready": {
                    document.querySelector('.matchmaking').hidden = true;
                    document.querySelector('.game').hidden = false;
                    document.querySelector('.iam').innerText = payload.i_am;
                    who_i_am = payload.i_am;
                    document.querySelector('.yourturn').hidden = who_i_am == "O";
                    break;
                }
                case "sync": {
                    let { ganador, tablero, proximo } = payload.data;
                    if (ganador) {
                        document.querySelector('.ganador').innerText = `El jugador ${ganador} ha ganado`;
                    }
                    let rows = document.querySelectorAll('.row');
                    [0, 1, 2].forEach((i) => {
                        let buttons = rows[i].querySelectorAll('button');
                        let tableroFila = tablero[i];
                        [0, 1, 2].forEach((j) =>  {
                            buttons[j].innerText = tableroFila[j];
                            buttons[j].classList.remove('X');
                            buttons[j].classList.remove('O');
                            if (tableroFila[j]) {
                                buttons[j].classList.add(tableroFila[j]);
                            }
                        });
                    });
                    document.querySelector('.yourturn').hidden = who_i_am != proximo;
                    break;
                }
            }
        })

        document.body.addEventListener('click', (e) => {
            if (e.target.classList.contains('position')) {
                let x = parseInt(e.target.getAttribute('data-x'));
                let y = parseInt(e.target.getAttribute('data-y'));
                socket.send(JSON.stringify({ type: "put", x, y }));
            }
        })