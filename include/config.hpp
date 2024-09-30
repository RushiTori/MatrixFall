#ifndef CONFIG_HPP
#define CONFIG_HPP

#include <SFML/Window/VideoMode.hpp>
#include <cstdint>
#include <string>

namespace cfg {
	inline uint32_t windowWidth = sf::VideoMode::getDesktopMode().width;
	inline uint32_t windowHeight = sf::VideoMode::getDesktopMode().height;
	inline std::string windowTitle = "Matrix Fall - Made with SFML";
	inline uint32_t maxFramerate = 60;

	inline uint32_t charWidth = 10;
	inline uint32_t gridWidth = windowWidth / charWidth;
	inline int32_t dropSpeed = 8;

} // namespace cfg

#endif // CONFIG_HPP
