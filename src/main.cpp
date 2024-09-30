#include "main.hpp"

CharDrop GenerateCharDrop() {
	CharDrop drop;
	drop.x = (std::rand() % cfg::gridWidth) * cfg::charWidth;
	drop.y = 0;
	drop.currChar = ' ';

	return drop;
}

int32_t main(void) {
	sf::RenderWindow window(sf::VideoMode(cfg::windowWidth, cfg::windowHeight), cfg::windowTitle,
							sf::Style::Fullscreen);
	window.setFramerateLimit(cfg::maxFramerate);

	sf::RenderTexture matrixTexture;

	if (!matrixTexture.create(cfg::windowWidth, cfg::windowHeight)) return 1;

	sf::Sprite matrixSprite(matrixTexture.getTexture());

	sf::Font matrixFont;

	if (!matrixFont.loadFromFile("ressources/fonts/PxPlus_IBM_BIOS.ttf")) return 1;

	sf::Text matrixText;

	matrixText.setFont(matrixFont);
	matrixText.setCharacterSize(10);
	matrixText.setFillColor(sf::Color::Green);
	matrixText.setPosition(sf::Vector2f(0, 0));
	matrixText.setString("Chirp chirp");

	sf::RectangleShape fog(sf::Vector2f(cfg::windowWidth, cfg::windowHeight));
	fog.setFillColor(sf::Color(0, 0, 0, 10));

	std::vector<CharDrop> drops;

	char dropBuffer[2] = {0};

	bool useUserInputs = false;

	while (window.isOpen()) {
		sf::Event event;
		while (window.pollEvent(event)) {
			if (event.type == sf::Event::Closed) {
				window.close();
				break;
			}
			if (event.type == sf::Event::KeyPressed) {
				if (event.key.code == sf::Keyboard::Escape) {
					window.close();
					break;
				}
				if (event.key.code == sf::Keyboard::Space) useUserInputs = !useUserInputs;
				if (useUserInputs) drops.emplace_back(GenerateCharDrop());
			}
		}
		if (!window.isOpen()) break;

		if (!useUserInputs && std::rand() % 3) drops.emplace_back(GenerateCharDrop());

		for (auto& drop : drops) {
			drop.currChar = std::rand() % (('~' - ' ') - 1) + ' ' + 1;
			dropBuffer[0] = drop.currChar;
			matrixText.setPosition(sf::Vector2f(drop.x, drop.y));
			matrixText.setString(dropBuffer);
			matrixTexture.draw(matrixText);
			drop.y += cfg::dropSpeed;
		}

		for (int32_t i = drops.size() - 1; i >= 0; i--) {
			if (drops[i].y >= cfg::windowHeight) {
				drops.erase(drops.begin() + i);
			}
		}
		matrixTexture.draw(fog);

		matrixTexture.display();

		window.clear();

		window.draw(matrixSprite);

		window.display();
	}
	return 0;
}
