async function changeLanguage(lang) {
            try {
                const response = await fetch('data/lang.json');
                const translations = await response.json();
                const texts = translations[lang];

                for (let id in texts) {
                    const el = document.getElementById(id);
                    if (el) el.innerHTML = texts[id];
                }

                document.querySelectorAll('.lang-btn').forEach(btn => btn.classList.remove('active'));
                document.getElementById(`btn-${lang}`).classList.add('active');
                localStorage.setItem('preferredLang', lang);
                document.documentElement.lang = lang;
            } catch (error) {
                console.error("Error cargando lang.json:", error);
            }
        }

        window.onload = () => {
            const savedLang = localStorage.getItem('preferredLang') || 'es';
            if (savedLang !== 'es') {
                changeLanguage(savedLang);
            } else {
                document.getElementById('btn-es').classList.add('active');
            }
        };

        // Función para mostrar/ocultar el botón de volver arriba
        window.onscroll = function() {
            const btn = document.getElementById("back-to-top");
            if (document.body.scrollTop > 400 || document.documentElement.scrollTop > 400) {
                btn.classList.add("show");
            } else {
                btn.classList.remove("show");
            }
        };

        function reveal() {
        var reveals = document.querySelectorAll(".reveal");

        for (var i = 0; i < reveals.length; i++) {
            var windowHeight = window.innerHeight;
            var elementTop = reveals[i].getBoundingClientRect().top;
            var elementVisible = 150; // Cuántos píxeles antes de verse debe activarse

            if (elementTop < windowHeight - elementVisible) {
            reveals[i].classList.add("active");
            }
        }
        }

        // Escuchamos el evento de scroll para ejecutar la función
        window.addEventListener("scroll", reveal);

        // También la ejecutamos una vez al cargar por si el usuario ya está en medio de la página
        reveal();