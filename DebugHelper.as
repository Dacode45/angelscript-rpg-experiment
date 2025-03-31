namespace Debug
{
	void Print(FString msg, const FLinearColor Color = FLinearColor::MakeRandomColor())
	{
		PrintToScreen(msg, 7.f, Color);
	}
}