#pragma once

#include "components/simple_scene.h"
#include "components/transform.h"
#include "core/gpu/particle_effect.h"

#include <string>


namespace m2
{
    class Lab6 : public gfxc::SimpleScene
    {
     public:
        Lab6();
        ~Lab6();

        void Init() override;

     private:
        void CreateFramebuffer(int width, int height);
        void FrameStart() override;
        void Update(float deltaTimeSeconds) override;
        void FrameEnd() override;

        unsigned int UploadCubeMapTexture(const std::string &pos_x, const std::string &pos_y, const std::string &pos_z, const std::string &neg_x, const std::string &neg_y, const std::string &neg_z);

        void OnInputUpdate(float deltaTime, int mods) override;
        void OnKeyPress(int key, int mods) override;
        void OnKeyRelease(int key, int mods) override;
        void OnMouseMove(int mouseX, int mouseY, int deltaX, int deltaY) override;
        void OnMouseBtnPress(int mouseX, int mouseY, int button, int mods) override;
        void OnMouseBtnRelease(int mouseX, int mouseY, int button, int mods) override;
        void OnMouseScroll(int mouseX, int mouseY, int offsetX, int offsetY) override;
        void OnWindowResize(int width, int height) override;

        void ResetParticlesFireworks(int xSize, int ySize, int zSize);
        void LoadShader(const std::string& name,
            const std::string& VS, const std::string& FS, const std::string& GS = "",
            bool hasGeomtery = false);

     private:
        int cubeMapTextureID;
        float angle;
        unsigned int framebuffer_object;
        unsigned int color_texture;
        unsigned int depth_texture;
        unsigned int type;

        float mirror_x, mirror_y, mirror_z, mirror_tilt_bf, mirror_tilt_lr, move_mirror, mirror_angle;
        bool move_f, move_b, rotate_l, rotate_r, tilt_f, tilt_b, tilt_l, tilt_r, mirror_reset;
        unsigned int mirror_scale, scene;

        glm::mat4 modelMatrix;
        glm::vec3 generator_position;
        GLenum polygonMode;
        float offset;
    };
}   // namespace m2
