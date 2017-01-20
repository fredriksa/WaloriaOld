public:
    ~RandomMovementGenerator() { if (i_path != nullptr) delete i_path; };

private:
    PathGenerator* i_path = nullptr;
    bool i_recalculateTravel;
